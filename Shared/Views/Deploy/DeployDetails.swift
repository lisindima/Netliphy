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
                if let eventDeploy = value.eventDeploy, !eventDeploy.isEmpty {
                    Section {
                        if let views = eventDeploy.filter { $0.type == "view" }, !views.isEmpty {
                            DisclosureGroup {
                                ForEach(views) { view in
                                    Text(view.type)
                                }
                            } label: {
                                LabelEventDeploy(
                                    title: "View",
                                    summary: "Unique page views for this Deploy Preview.",
                                    icon: "eye"
                                ).badge(views.count)
                            }
                        }
                        if let comments = eventDeploy.filter { $0.type == "comment" }, !comments.isEmpty {
                            DisclosureGroup {
                                ForEach(comments) { comment in
                                    Text(comment.type)
                                }
                            } label: {
                                LabelEventDeploy(
                                    title: "Comments",
                                    summary: "Number of comments left by your team.",
                                    icon: "ellipsis.bubble"
                                ).badge(comments.count)
                            }
                        }
                    }
                }
                DisclosureGroup {
                    ForEach(value.deploy.links.keys.sorted(), id: \.self) { key in
                        if let link = value.deploy.links[key] {
                            Link(link.absoluteString, destination: link)
                        }
                    }
                } label: {
                    Label("Links", systemImage: "link")
                        .font(.body.weight(.bold))
                        .badge(value.deploy.links.count)
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

struct LabelEventDeploy: View {
    let title: String
    let summary: String
    let icon: String
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                Text(summary)
                    .font(.footnote)
            }
        } icon: {
            Image(systemName: icon)
                .font(.body.weight(.bold))
        }
    }
}
