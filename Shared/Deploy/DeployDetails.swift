//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @State private var deployLoadingState: LoadingState<Deploy> = .loading
    
    var deploy: Deploy
    
    private func getDeploy() {
        Endpoint.api.fetch(.deploy(siteId: deploy.siteId, deploy: deploy.id)) { (result: Result<Deploy, ApiError>) in
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
    private func createInfoDeploy(_ deploy: Deploy) -> some View {
        FormItems(title: "Build id", value: deploy.buildId)
        FormItems(title: "State", value: deploy.state.rawValue)
        if let errorMessage = deploy.errorMessage {
            FormItems(title: "Error message", value: errorMessage)
        }
        Link(destination: deploy.deployUrl) {
            FormItems(title: "Deploy URL", value: "\(deploy.deployUrl)")
        }
        FormItems(title: "Branch", value: deploy.branch)
        if let title = deploy.title {
            FormItems(title: "Title", value: title)
        }
        if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
            Link(destination: commitUrl) {
                FormItems(title: "Commit", value: commitRef)
            }
        }
        if let committer = deploy.committer {
            FormItems(title: "Committer", value: committer)
        }
        FormItems(title: "Context", value: deploy.context)
        if let framework = deploy.framework {
            FormItems(title: "Framework", value: framework)
        }
    }
    
    var body: some View {
        LoadingView(loadingState: $deployLoadingState, load: getDeploy) { deploy in
            Form {
                Section(header: Text("section_header_summary_deploy")) {
                    if let summary = deploy.summary, !summary.messages.isEmpty {
                        ForEach(summary.messages, id: \.self, content: SummaryItems.init)
                    } else if deploy.state == .error {
                        SummaryItems(message: .error)
                    } else if deploy.state == .building {
                        SummaryItems(message: .building)
                    }
                }
                Section(header: Text("section_header_info_deploy")) {
                    createInfoDeploy(deploy)
                }
                Section {
                    if let logAccessAttributes = deploy.logAccessAttributes {
                        NavigationLink(destination: LogView(logAccessAttributes: logAccessAttributes)) {
                            Label("section_navigation_link_log", systemImage: "rectangle.and.text.magnifyingglass")
                        }
                    }
                }
            }
        }
        .navigationTitle(deploy.branch + "@" + (deploy.commitRef ?? "").prefix(7))
    }
}
