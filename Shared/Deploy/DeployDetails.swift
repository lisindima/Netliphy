//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @State private var deployLoadingState: LoadingState<Deploy> = .loading(.placeholder)
    
    let deployId: String
    
    var body: some View {
        LoadingView(
            loadingState: $deployLoadingState,
            failure: { error in
                FailureView(error.localizedDescription, action: getDeploy)
            }
        ) { deploy in
            List {
                Section(header: Text("section_header_summary_deploy")) {
                    switch deploy.state {
                    case .ready:
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.self, content: SummaryItems.init)
                        }
                    case .error:
                        SummaryItems(message: .error)
                    case .building:
                        SummaryItems(message: .building)
                    case .new:
                        SummaryItems(message: .new)
                    }
                }
                Section(header: Text("section_header_info_deploy")) {
                    createInfoDeploy(deploy: deploy)
                }
                Section {
                    Link(destination: deploy.deployUrl) {
                        Text("Open deploy url")
                    }
                    if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                        Link(destination: commitUrl) {
                            Text("View commit (\(String(commitRef.prefix(7))))")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                        Label("section_navigation_link_log", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle(deployId)
        .onAppear(perform: getDeploy)
    }
    
    private func getDeploy() {
        Endpoint.api.fetch(.deploy(deployId: deployId)) { (result: Result<Deploy, ApiError>) in
            switch result {
            case let .success(value):
                deployLoadingState = .success(value)
            case let .failure(error):
                deployLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    @ViewBuilder
    private func createInfoDeploy(deploy: Deploy) -> some View {
        Group {
            if let createdAt = deploy.createdAt {
                FormItems("Deploy created", value: createdAt.siteDate)
            }
            if let updatedAt = deploy.updatedAt {
                FormItems("Deploy updated", value: updatedAt.siteDate)
            }
            if let reviewId = deploy.reviewId {
                FormItems("Review id", value: "\(reviewId)")
            }
        }
        Group {
            FormItems("State", value: deploy.state.rawValue)
            if let errorMessage = deploy.errorMessage {
                FormItems("Error message", value: errorMessage)
            }
            if let deployTime = deploy.deployTime {
                FormItems("Deploy time", value: deployTime.convertedDeployTime(.full))
            }
            if let branch = deploy.branch {
                FormItems("Branch", value: branch)
            }
            if let title = deploy.title {
                FormItems("Title", value: title)
            }
            if let committer = deploy.committer {
                FormItems("Committer", value: committer)
            }
            FormItems("Context", value: deploy.context.prettyValue)
            if let framework = deploy.framework {
                FormItems("Framework", value: framework)
            }
        }
    }
}
