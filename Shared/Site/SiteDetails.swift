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
                Link("Open admin panel", destination: site.adminUrl)
            } header: {
                Text("Site information")
            }
            Section {
                FormItems("Branch", value: site.buildSettings.repoBranch)
                FormItems("Build image", value: site.buildImage)
                FormItems("Build command", value: site.buildSettings.cmd)
                FormItems("Publish directory", value: site.buildSettings.dir)
                if let repoUrl = site.buildSettings.repoUrl {
                    Link("Open repository", destination: repoUrl)
                }
            } header: {
                Text("Build settings")
            }
            Section {
                if let publishedDeploy = site.publishedDeploy {
                    NavigationLink {
                        DeployDetails(deployId: publishedDeploy.id)
                    } label: {
                        Label("Published deploy", systemImage: "bolt.fill")
                    }
                }
                if !site.plugins.isEmpty {
                    NavigationLink {
                        PluginsView(plugins: site.plugins)
                    } label: {
                        Label("Plugins", systemImage: "square.stack.3d.down.right.fill")
                    }
                }
                if let env = site.buildSettings.env, !env.isEmpty {
                    NavigationLink {
                        EnvView(env: env)
                    } label: {
                        Label("Environment variables", systemImage: "tray.full.fill")
                    }
                }
                #if os(iOS)
                NavigationLink {
                    NotificationsView(siteId: site.id, forms: site.capabilities.forms)
                } label: {
                    Label("Notifications", systemImage: "bell.badge.fill")
                }
                #endif
            }
            Section {
                LoadingView(viewModel.deploysLoadingState) { deploys in
                    ForEach(deploys, id: \.id, content: DeployItems.init)
                    if case let .success(value) = viewModel.deploysLoadingState, value.count >= 5 {
                        NavigationLink {
                            DeploysList(siteId: site.id)
                        } label: {
                            Text("More")
                        }
                    }
                }
                .task {
                    await viewModel.listSiteDeploys(site.id)
                }
            } header: {
                Text("Deploys")
            }
            if site.capabilities.forms != nil {
                Section {
                    LoadingView(viewModel.formsLoadingState) { forms in
                        ForEach(forms, id: \.id, content: SiteFormItems.init)
                    }
                    .task {
                        await viewModel.listSiteForms(site.id)
                    }
                } header: {
                    Text("Forms")
                }
            }
            if site.capabilities.functions != nil {
                Section {
                    LoadingView(viewModel.functionsLoadingState) { functions in
                        ForEach(functions.functions, id: \.id) { function in
                            FunctionItems(function: function, siteId: site.id)
                        }
                    }
                    .task {
                        await viewModel.listSiteFunctions(site.id)
                    }
                } header: {
                    Text("Functions")
                }
            }
            Section {
                Button("Delete site", role: .destructive) {
                    openConfirmationDialog = true
                }
            }
        }
        .refreshable {
            await viewModel.load(site.id)
        }
        .navigationTitle(site.name)
        .confirmationDialog("Are you absolutely sure you want to delete \(site.name)?", isPresented: $openConfirmationDialog) {
            Button("Delete site", role: .destructive) {
                Task {
                    await deleteSite()
                }
            }
            Button("Cancel", role: .cancel) {
                openConfirmationDialog = false
            }
        }
        .toolbar {
            Link(destination: site.url) {
                Label("Open site", systemImage: "safari.fill")
            }
        }
    }
    
    @MainActor
    private func deleteSite() async {
        do {
            try await Loader.shared.response(.site(site.id), httpMethod: .delete)
            dismiss()
        } catch {
            print(error)
        }
    }
}
