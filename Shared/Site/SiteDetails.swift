//
//  SiteDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Kingfisher
import SwiftUI

struct SiteDetails: View {
    @Environment(\.presentationMode) @Binding private var presentationMode
    
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 3))
    @State private var formsLoadingState: LoadingState<[SiteForm]> = .loading(Array(repeating: .placeholder, count: 3))
    @State private var alertItem: AlertItem?
    @State private var showActionSheet: Bool = false
    
    let site: Site
    
    var body: some View {
        List {
            KFImage(site.screenshotUrl)
                .resizable()
                .placeholder {
                    Image("placeholder")
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                }
                .loadImmediately()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .padding(.vertical)
            Section(header: Text("section_header_about_site")) {
                FormItems("Site created", value: site.createdAt.siteDate)
                FormItems("Site updated", value: site.updatedAt.siteDate)
                FormItems("Owner", value: site.accountName)
                FormItems("Account type", value: site.accountType)
                Link(destination: site.adminUrl) {
                    Text("button_admin_panel")
                }
            }
            Section(
                header: Text("section_header_build_settings"),
                footer: footerBuildSettings
            ) {
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
                    Link(destination: repoUrl) {
                        Text("Open repository")
                    }
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
            Section(header: headerSiteDeploys) {
                LoadingView(
                    loadingState: $deploysLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { deploys in
                    ForEach(deploys, id: \.id, content: DeployItems.init)
                }
                .onAppear(perform: listSiteDeploys)
            }
            if site.capabilities.forms != nil {
                Section(header: Text("section_header_forms"), footer: footerForms) {
                    LoadingView(
                        loadingState: $formsLoadingState,
                        failure: { error in
                            FailureFormView(error.localizedDescription)
                        }
                    ) { forms in
                        ForEach(forms, id: \.id, content: SiteFormItems.init)
                    }
                    .onAppear(perform: listSiteForms)
                }
            }
            Section {
                Button(action: { showActionSheet = true }) {
                    Label("button_delete_site", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(site.name)
        .customAlert(item: $alertItem)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("action_sheet_title_delete_site"),
                message: Text("action_sheet_message_delete_site"),
                buttons: [
                    .destructive(Text("button_delete_site"), action: deleteSite),
                    .cancel(),
                ]
            )
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("button_open_site", systemImage: "safari.fill")
                }
            }
        }
    }
    
    private func dismissView() {
        presentationMode.dismiss()
    }
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: site.id, items: 5)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                deploysLoadingState = .success(value)
            case let .failure(error):
                deploysLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    private func listSiteForms() {
        Endpoint.api.fetch(.forms(siteId: site.id)) { (result: Result<[SiteForm], ApiError>) in
            switch result {
            case let .success(value):
                formsLoadingState = .success(value)
            case let .failure(error):
                formsLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    private func deleteSite() {
        Endpoint.api.fetch(.site(siteId: site.id), httpMethod: .delete) { (result: Result<Site, ApiError>) in
            switch result {
            case .success, .failure:
                alertItem = AlertItem(title: "alert_success_title", message: "alert_success_delete_site", action: dismissView)
            }
        }
    }
    
    var headerSiteDeploys: some View {
        HStack {
            Text("section_header_builds")
            Spacer()
            if case let .success(value) = deploysLoadingState, value.count >= 5 {
                NavigationLink(destination: DeploysList(siteId: site.id)) {
                    Text("section_header_button_builds")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    var footerBuildSettings: some View {
        Link(destination: URL(string: "https://docs.netlify.com/configure-builds/common-configurations/")!) {
            Text("footer_build_settings")
        }
    }
    
    var footerForms: some View {
        Link(destination: URL(string: "https://docs.netlify.com/forms/setup/")!) {
            Text("section_footer_forms")
        }
    }
}
