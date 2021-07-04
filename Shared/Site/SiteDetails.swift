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
    
    @State private var alertItem: AlertItem?
    @State private var openConfirmationDialog: Bool = false
    
    let site: Site
    
    var body: some View {
        List {
            Section {
                AsyncImage(url: site.screenshotUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .listRowInsets(EdgeInsets())
            Section(header: Text("Site information")) {
                FormItems("Site created", value: site.createdAt.formatted())
                FormItems("Site updated", value: site.updatedAt.formatted())
                FormItems("Owner", value: site.accountName)
                FormItems("Account type", value: site.accountType)
                Link("Open admin panel", destination: site.adminUrl)
            }
            Section(header: Text("Build settings")) {
                if let repoBranch = site.buildSettings.repoBranch {
                    FormItems("Branch", value: repoBranch)
                }
                FormItems("Build image", value: site.buildImage)
                if let cmd = site.buildSettings.cmd {
                    FormItems("Build command", value: cmd)
                }
                if let dir = site.buildSettings.dir {
                    FormItems("Publish directory", value: dir)
                }
                if let repoUrl = site.buildSettings.repoUrl {
                    Link("Open repository", destination: repoUrl)
                }
            }
            Section {
                if let publishedDeploy = site.publishedDeploy {
                    NavigationLink(destination: DeployDetails(deployId: publishedDeploy.id)) {
                        Label("Published deploy", systemImage: "bolt.fill")
                    }
                }
                if !site.plugins.isEmpty {
                    NavigationLink(destination: PluginsView(plugins: site.plugins)) {
                        Label("Plugins", systemImage: "square.stack.3d.down.right.fill")
                    }
                }
                if let env = site.buildSettings.env, !env.isEmpty {
                    NavigationLink(destination: EnvView(env: env)) {
                        Label("Environment variables", systemImage: "tray.full.fill")
                    }
                }
                NavigationLink(destination: NotificationsView(siteId: site.id, forms: site.capabilities.forms)) {
                    Label("Notifications", systemImage: "bell.badge.fill")
                }
            }
            Section(header: Text("Deploys")) {
                LoadingView(
                    loadingState: viewModel.deploysLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { deploys in
                    ForEach(deploys, id: \.id, content: DeployItems.init)
                    if case let .success(value) = viewModel.deploysLoadingState, value.count >= 5 {
                        NavigationLink(destination: DeploysList(siteId: site.id)) {
                            Text("More")
                        }
                    }
                }
                .task {
                    async {
                        await viewModel.listSiteDeploys(site.id)
                    }
                }
            }
            if site.capabilities.forms != nil {
                Section(header: Text("Forms")) {
                    LoadingView(
                        loadingState: viewModel.formsLoadingState,
                        failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                    ) { forms in
                        ForEach(forms, id: \.id, content: SiteFormItems.init)
                    }
                    .task {
                        async {
                            await viewModel.listSiteForms(site.id)
                        }
                    }
                }
            }
            if site.capabilities.functions != nil {
                Section(header: Text("Functions")) {
                    LoadingView(
                        loadingState: viewModel.functionsLoadingState,
                        failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                    ) { functions in
                        ForEach(functions.functions, id: \.id) { function in
                            FunctionItems(function: function, siteId: site.id)
                        }
                    }
                    .task {
                        async {
                            await viewModel.listSiteFunctions(site.id)
                        }
                    }
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
        .customAlert(item: $alertItem)
        .confirmationDialog("Are you absolutely sure you want to delete \(site.name)?", isPresented: $openConfirmationDialog) {
            Button("Delete site", role: .destructive) {
                async {
                    await deleteSite()
                }
            }
            Button("Cancel", role: .cancel) {
                openConfirmationDialog = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("Open site", systemImage: "safari.fill")
                }
            }
        }
    }
    
    private func deleteSite() async {
        do {
            try await Loader.shared.response(.site(site.id), httpMethod: .delete)
            alertItem = AlertItem(title: "Success", message: "Site deleted successfully.", action: { dismiss() })
        } catch {
            print(error)
        }
    }
}
