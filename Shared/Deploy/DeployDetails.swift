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
    
    @State private var showAlert: Bool = false
    
    let deployId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { deploy in
            List {
                if case .ready = deploy.state {
                    Section {
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.id, content: SummaryItems.init)
                        }
                    } header: {
                        Text("Summary")
                    }
                }
                Section {
                    deploy.state
                    deploy.context
                } header: {
                    Text("Deployment status")
                }
                if case .building = deploy.state {
                    Button("Cancel deploy") {
                        Task {
                            await deployAction(.cancel(deployId))
                        }
                    }
                } else {
                    Button("Retry deploy") {
                        Task {
                            await deployAction(.retry(deployId))
                        }
                    }
                }
                Section {
                    FormItems("Deploy created", value: deploy.createdAt.formatted())
                    FormItems("Deploy updated", value: deploy.updatedAt.formatted())
                    FormItems("Site name", value: deploy.name)
                    if let deployTime = deploy.deployTime {
                        FormItems("Deploy time", value: deployTime.convertedDeployTime)
                    }
                    FormItems("Error message", value: deploy.errorMessage)
                    FormItems("Framework", value: deploy.framework)
                    Link("Open deploy", destination: deploy.deployUrl)
                } header: {
                    Text("Deploy information")
                }
                if !deploy.manualDeploy {
                    Section {
                        FormItems("Branch", value: deploy.branch)
                        FormItems("Title", value: deploy.title)
                        FormItems("Committer", value: deploy.committer)
                        if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                            Link("View commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                        }
                    } header: {
                        Text("Commit information")
                    }
                }
                #if !os(watchOS)
                Section {
                    NavigationLink {
                        LogView(logAccessAttributes: deploy.logAccessAttributes)
                    } label: {
                        Label("Deploy log", systemImage: "terminal")
                    }
                }
                #endif
            }
            .refreshable {
                await viewModel.load(deployId)
            }
        }
        .navigationTitle(deployId)
        .alert("Error", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("An error occurred during the execution of the action, check the Internet connection and the rights to this action.")
        }
        .task {
            await viewModel.load(deployId)
        }
        .userActivity("com.darkfox.netliphy.deploy") { activity in
            activity.addUserInfoEntries(
                from: [
                    "url": URL(string: "netliphy://open?deployId=\(deployId)")!,
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
            showAlert = true
            print(error)
        }
    }
}
