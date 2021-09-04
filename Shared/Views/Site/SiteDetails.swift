//
//  SiteDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct SiteDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = SiteViewModel()
    
    @State private var openConfirmationDialog: Bool = false
    @State private var showAlert: Bool = false
    
    let site: Site
    
    var body: some View {
        List {
            Section {
                AsyncImage(url: site.screenshotUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                }
                .aspectRatio(contentMode: .fit)
            }
            .listRowInsets(EdgeInsets())
            Section {
                FormItems("Site created", value: site.createdAt.formatted())
                FormItems("Site updated", value: site.updatedAt.formatted())
                FormItems("Owner", value: site.accountName)
                FormItems("Account type", value: site.accountType)
            }
            Section {
                FormItems("Branch", value: site.buildSettings.repoBranch)
                FormItems("Build image", value: site.buildImage)
                FormItems("Build command", value: site.buildSettings.cmd)
                FormItems("Publish directory", value: site.buildSettings.dir)
            }
            Section {
                if let publishedDeploy = site.publishedDeploy {
                    NavigationLink {
                        DeployDetails(deployId: publishedDeploy.id)
                    } label: {
                        Label("Published Deploy", systemImage: "bolt.fill")
                    }
                }
                if !site.plugins.isEmpty {
                    NavigationLink {
                        PluginsView(installedPlugins: site.plugins)
                    } label: {
                        Label("Plugins", systemImage: "square.stack.3d.down.right.fill")
                    }
                }
                if let env = site.buildSettings.env, !env.isEmpty {
                    NavigationLink {
                        EnvView(env: env)
                    } label: {
                        Label("Environment Variables", systemImage: "tray.full.fill")
                    }
                }
                #if os(iOS)
                NavigationLink {
                    NotificationsView(siteId: site.id, forms: site.capabilities.forms)
                } label: {
                    Label("Notifications", systemImage: "bell.badge.fill")
                }
                #endif
                if site.capabilities.functions != nil || site.capabilities.forms != nil || site.capabilities.identity != nil {
                    NavigationLink {
                        UsageView(siteId: site.id)
                    } label: {
                        Label("Usage", systemImage: "chart.bar.xaxis")
                    }
                }
                NavigationLink {
                    FilesList(siteId: site.id)
                } label: {
                    Label("Files", systemImage: "doc.on.doc.fill")
                }
            }
            LoadingView(viewModel.loadingState) { value in
                Section {
                    ForEach(value.deploys, content: DeployItems.init)
                } header: {
                    HStack {
                        Text("Deploys")
                        Spacer()
                        if value.deploys.count >= 5 {
                            NavigationLink {
                                DeploysList(siteId: site.id)
                            } label: {
                                Text("More")
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
                .headerProminence(.increased)
                if site.capabilities.forms != nil {
                    Section {
                        ForEach(value.forms, content: SiteFormItems.init)
                    } header: {
                        Text("Forms")
                    }
                    .headerProminence(.increased)
                }
                if site.capabilities.functions != nil, let functions = value.functions.functions {
                    Section {
                        ForEach(functions) { function in
                            FunctionItems(function: function, siteId: site.id)
                        }
                    } header: {
                        Text("Functions")
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .navigationTitle(site.name)
        .refreshable {
            await viewModel.load(site.id)
        }
        .alert("Error", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("An error occurred during the execution of the action, check the Internet connection and the rights to this action.")
        }
        .confirmationDialog("Are you absolutely sure you want to delete \(site.name)?", isPresented: $openConfirmationDialog) {
            Button("Delete Site", role: .destructive) {
                Task {
                    await deleteSite()
                }
            }
            Button("Cancel", role: .cancel) {
                openConfirmationDialog = false
            }
        }
        .toolbar {
            Menu {
                Section {
                    Link(destination: site.url) {
                        Label("Open Site", systemImage: "safari.fill")
                    }
                }
                Section {
                    Link(destination: site.adminUrl) {
                        Label("Open Admin Panel", systemImage: "display")
                    }
                    if let repoUrl = site.buildSettings.repoUrl {
                        Link(destination: repoUrl) {
                            Label("Open Repository", systemImage: "rectangle.stack.fill")
                        }
                    }
                }
                Section {
                    Button(role: .destructive) {
                        openConfirmationDialog = true
                    } label: {
                        Label("Delete Site", systemImage: "trash")
                    }
                }
            } label: {
                Label("Open Menu", systemImage: "ellipsis.circle.fill")
            }
        }
        .task {
            await viewModel.load(site.id)
        }
    }
    
    @MainActor
    private func deleteSite() async {
        do {
            try await Loader.shared.response(for: .site(site.id), httpMethod: .delete)
            dismiss()
        } catch {
            showAlert = true
            print(error)
        }
    }
}
