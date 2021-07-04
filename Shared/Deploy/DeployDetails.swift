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
                    Section(header: Text("Summary")) {
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.id, content: SummaryItems.init)
                        }
                    }
                }
                Section(header: Text("Deployment status")) {
                    deploy.state
                    deploy.context
                }
                if case .building = deploy.state {
                    Button("Cancel deploy") {
                        async {
                            await deployAction(.cancel(deployId))
                        }
                    }
                } else {
                    Button("Retry deploy") {
                        async {
                            await deployAction(.retry(deployId))
                        }
                    }
                }
                Section(header: Text("Deploy information")) {
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
                    Link("Open deploy", destination: deploy.deployUrl)
                }
                if !deploy.manualDeploy {
                    Section(header: Text("Commit information")) {
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
                            Link("View commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                        Label("Deploy log", systemImage: "terminal")
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
    
    @MainActor
    private func deployAction(_ endpoint: Endpoint) async {
        do {
            try await Loader.shared.response(endpoint, httpMethod: .post)
            dismiss()
        } catch {
            print(error)
        }
    }
}
