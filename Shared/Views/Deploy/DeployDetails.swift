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
                if !value.pluginRun.isEmpty {
                    DisclosureGroup {
                        ForEach(value.pluginRun, content: PluginRunItems.init)
                    } label: {
                        CustomLabel(
                            title: "Plugins State",
                            summary: value.deploy.pluginState.prettyValue,
                            icon: "square.stack.3d.down.right.fill"
                        ).badge(value.pluginRun.count)
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
                        .modifier(PrimaryButtonViewModifier())
                    }
                    if case .ready = value.deploy.state, deployId != value.site.publishedDeploy?.id {
                        Button("Publish deploy") {
                            Task {
                                await deployAction(.restore(deployId))
                            }
                        }
                        .modifier(SecondaryButtonViewModifier())
                    }
                    if deployId == value.site.publishedDeploy?.id {
                        if let locked = value.deploy.locked, locked {
                            Button("Unlock deploy") {
                                Task {
                                    await deployAction(.unlock(deployId))
                                }
                            }
                            .modifier(SecondaryButtonViewModifier())
                        } else {
                            Button("Lock deploy") {
                                Task {
                                    await deployAction(.lock(deployId))
                                }
                            }
                            .modifier(SecondaryButtonViewModifier())
                        }
                    }
                }
                .listRowSeparator(.hidden)
                if let eventDeploy = value.eventDeploy, !eventDeploy.isEmpty {
                    Section {
                        if let views = eventDeploy.filter { $0.type == .view }, !views.isEmpty {
                            DisclosureGroup {
                                ForEach(views, content: EventDeployItems.init)
                            } label: {
                                CustomLabel(
                                    title: "View",
                                    summary: "Unique page views for this Deploy Preview.",
                                    icon: "eye"
                                ).badge(views.count)
                            }
                        }
                        if let comments = eventDeploy.filter { $0.type == .comment }, !comments.isEmpty {
                            DisclosureGroup {
                                ForEach(comments, content: EventDeployItems.init)
                            } label: {
                                CustomLabel(
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
                                .lineLimit(1)
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

struct CustomLabel: View {
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
