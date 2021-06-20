//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @StateObject private var viewModel = DeployViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    let deployId: String
    
    var body: some View {
        LoadingView(
            loadingState: viewModel.deployLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { deploy in
            List {
                if case .ready = deploy.state {
                    Section(header: Text("section_header_summary_deploy")) {
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.id, content: SummaryItems.init)
                        }
                    }
                }
                Section(header: Text("section_header_status_deploy")) {
                    deploy.state
                    deploy.context
                }
                if case .building = deploy.state {
                    Button("button_title_cancel_deploy") {
                        async {
                            await deployAction(.cancel(deployId))
                        }
                    }
                } else {
                    Button("button_title_retry_deploy") {
                        async {
                            await deployAction(.retry(deployId))
                        }
                    }
                }
                Section(header: Text("section_header_info_deploy")) {
                    if let createdAt = deploy.createdAt {
                        FormItems("Deploy created", value: createdAt.formatted())
                    }
                    if let updatedAt = deploy.updatedAt {
                        FormItems("Deploy updated", value: updatedAt.formatted())
                    }
                    FormItems("Site name", value: deploy.name)
                    if let deployTime = deploy.deployTime {
                        FormItems("Deploy time", value: deployTime.convertedDeployTime)
                    }
                    if let errorMessage = deploy.errorMessage {
                        FormItems("Error message", value: errorMessage)
                    }
                    if let framework = deploy.framework {
                        FormItems("Framework", value: framework)
                    }
                    Link("button_open_deploy_url", destination: deploy.deployUrl)
                }
                if !deploy.manualDeploy {
                    Section(header: Text("section_header_commit_information")) {
                        if let branch = deploy.branch {
                            FormItems("Branch", value: branch)
                        }
                        if let title = deploy.title {
                            FormItems("Title", value: title)
                        }
                        if let committer = deploy.committer {
                            FormItems("Committer", value: committer)
                        }
                        if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                            Link("button_title_view_commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                        Label("section_navigation_link_log", systemImage: "terminal")
                    }
                }
            }
            .refreshable {
                await viewModel.load(deployId)
            }
        }
        .navigationTitle(deployId)
        .task {
            await viewModel.load(deployId)
        }
        .userActivity("com.darkfox.netliphy.deploy", element: deployId) { id, activity in
            activity.addUserInfoEntries(
                from: [
                    "url": URL(string: "netliphy://open?deployId=\(id)")!,
                ]
            )
        }
    }
    
    private func deployAction(_ endpoint: Endpoint) async {
        do {
            try await Loader.shared.response(endpoint, httpMethod: .post)
            DispatchQueue.main.async {
                dismiss()
            }
        } catch {
            print(error)
        }
    }
}
