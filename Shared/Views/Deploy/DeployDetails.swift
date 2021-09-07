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
        LoadingView(viewModel.loadingState) { value in
            List {
                Section {
                    value.deploy.state
                    value.deploy.context
                }
                if let summary = value.deploy.summary {
                    ForEach(summary.messages, content: SummaryItems.init)
                }
                if !value.pluginState.isEmpty {
                    DisclosureGroup {
                        ForEach(value.pluginState, content: PluginStateItems.init)
                    } label: {
                        Label("Plugins State", systemImage: "square.stack.3d.down.right.fill")
                            .font(.body.weight(.bold))
                            .badge(value.pluginState.count)
                    }
                }
                Section {
                    if case .building = value.deploy.state {
                        Button("Cancel deploy") {
                            Task {
                                await deployAction(.cancel(deployId))
                            }
                        }
                        .modifier(RedButtonViewModifier())
                    } else {
                        Button("Retry deploy") {
                            Task {
                                await deployAction(.retry(deployId))
                            }
                        }
                        .modifier(ListButtonViewModifier())
                    }
                }
                Section {
                    FormItems("Deploy created", value: value.deploy.createdAt.formatted())
                    FormItems("Deploy updated", value: value.deploy.updatedAt.formatted())
                    FormItems("Site name", value: value.deploy.name)
                    if let deployTime = value.deploy.deployTime {
                        FormItems("Deploy time", value: deployTime.convertToFullTime)
                    }
                    FormItems("Error message", value: value.deploy.errorMessage)
                    FormItems("Framework", value: value.deploy.framework)
                    Link("Open deploy", destination: value.deploy.deployUrl)
                }
                if !value.deploy.manualDeploy {
                    Section {
                        FormItems("Branch", value: value.deploy.branch)
                        FormItems("Title", value: value.deploy.title)
                        FormItems("Committer", value: value.deploy.committer)
                        if let commitUrl = value.deploy.commitUrl, let commitRef = value.deploy.commitRef {
                            Link("View commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                        }
                    }
                }
                Section {
                    NavigationLink {
                        LogView(logAccessAttributes: value.deploy.logAccessAttributes)
                    } label: {
                        Label("Deploy log", systemImage: "terminal")
                    }
                }
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
                    "url": URL(string: "netliphy://open?deployId=\(deployId)")!
                ]
            )
        }
    }
    
    @MainActor
    private func deployAction(_ endpoint: Endpoint) async {
        do {
            try await Loader.shared.response(for: endpoint, httpMethod: .post)
            dismiss()
        } catch {
            showAlert = true
            print(error)
        }
    }
}
