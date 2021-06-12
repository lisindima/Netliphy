//
//  SiteDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct SiteDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 3))
    @State private var formsLoadingState: LoadingState<[SiteForm]> = .loading(Array(repeating: .placeholder, count: 3))
    @State private var functionsLoadingState: LoadingState<FunctionInfo> = .loading(.placeholder)
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
                    loadingState: $deploysLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { deploys in
                    ForEach(deploys, id: \.id, content: DeployItems.init)
                }
                .onAppear {
                    async {
                        await listSiteDeploys()
                    }
                }
            }
            Group {
                if site.capabilities.forms != nil {
                    Section(header: Text("section_header_forms")) {
                        LoadingView(
                            loadingState: $formsLoadingState,
                            failure: { error in
                                FailureFormView(error.localizedDescription)
                            }
                        ) { forms in
                            ForEach(forms, id: \.id, content: SiteFormItems.init)
                        }
                        .onAppear {
                            async {
                                await listSiteForms()
                            }
                        }
                    }
                }
                if site.capabilities.functions != nil {
                    Section(header: Text("section_header_functions")) {
                        LoadingView(
                            loadingState: $functionsLoadingState,
                            failure: { error in
                                FailureFormView(error.localizedDescription)
                            }
                        ) { functions in
                            ForEach(functions.functions, id: \.id) { function in
                                FunctionItems(function: function, siteId: site.id)
                            }
                        }
                        .onAppear {
                            async {
                                await listSiteFunctions()
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
            if case let .success(value) = deploysLoadingState, value.count >= 5 {
                NavigationLink(destination: DeploysList(siteId: site.id)) {
                    Text("section_header_button_more")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private func listSiteDeploys() async {
        do {
            let value: [Deploy] = try await Loader.shared.fetch(.deploys(siteId: site.id, items: 5))
            deploysLoadingState = .success(value)
        } catch {
            deploysLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func listSiteForms() async {
        do {
            let value: [SiteForm] = try await Loader.shared.fetch(.forms(siteId: site.id))
            formsLoadingState = .success(value)
        } catch {
            formsLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func listSiteFunctions() async {
        do {
            let value: FunctionInfo = try await Loader.shared.fetch(.functions(siteId: site.id))
            functionsLoadingState = .success(value)
        } catch {
            functionsLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func deleteSite() async {
        do {
            _ = try await Loader.shared.response(.site(siteId: site.id), httpMethod: .delete)
            alertItem = AlertItem(title: "alert_success_title", message: "alert_success_delete_site", action: { dismiss() })
        } catch {
            print(error)
        }
    }
}
