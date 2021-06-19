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
            Section(header: Text("section_header_about_site")) {
                FormItems("Site created", value: site.createdAt.formatted())
                FormItems("Site updated", value: site.updatedAt.formatted())
                FormItems("Owner", value: site.accountName)
                FormItems("Account type", value: site.accountType)
                Link("button_admin_panel", destination: site.adminUrl)
            }
            Section(header: Text("section_header_build_settings")) {
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
                    Link("button_open_repository", destination: repoUrl)
                }
            }
            if let publishedDeploy = site.publishedDeploy {
                NavigationLink(destination: DeployDetails(deployId: publishedDeploy.id)) {
                    Label("button_title_published_deploy", systemImage: "bolt.fill")
                }
            }
            if !site.plugins.isEmpty {
                NavigationLink(destination: PluginsView(plugins: site.plugins)) {
                    Label("button_title_plugins", systemImage: "square.stack.3d.down.right.fill")
                }
            }
            if let env = site.buildSettings.env, !env.isEmpty {
                NavigationLink(destination: EnvView(env: env)) {
                    Label("button_title_env", systemImage: "tray.full.fill")
                }
            }
            NavigationLink(destination: NotificationsView(siteId: site.id, forms: site.capabilities.forms)) {
                Label("button_title_notifications", systemImage: "bell.badge.fill")
            }
            Section(header: headerSiteDeploys) {
                LoadingView(
                    loadingState: viewModel.deploysLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { deploys in
                    ForEach(deploys, id: \.id, content: DeployItems.init)
                }
                .task {
                    async {
                        await viewModel.listSiteDeploys(site.id)
                    }
                }
            }
            Group {
                if site.capabilities.forms != nil {
                    Section(header: Text("section_header_forms")) {
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
                    Section(header: Text("section_header_functions")) {
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
            }
            Section {
                Button {
                    async {
                        await deleteSite()
                    }
                } label: {
                    Label("button_delete_site", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle(site.name)
        .customAlert(item: $alertItem)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("button_open_site", systemImage: "safari.fill")
                }
            }
        }
    }
    
    var headerSiteDeploys: some View {
        HStack {
            Text("section_header_deploys")
            Spacer()
            if case let .success(value) = viewModel.deploysLoadingState, value.count >= 5 {
                NavigationLink(destination: DeploysList(siteId: site.id)) {
                    Text("section_header_button_more")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private func deleteSite() async {
        do {
            try await Loader.shared.response(.site(siteId: site.id), httpMethod: .delete)
            alertItem = AlertItem(title: "alert_success_title", message: "alert_success_delete_site", action: { dismiss() })
        } catch {
            print(error)
        }
    }
}
