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
    
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading
    @State private var alertItem: AlertItem?
    @State private var showActionSheet: Bool = false
    
    var site: Site
    
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
    
    private func deleteSite() {
        Endpoint.api.fetch(.sites(siteId: site.id), httpMethod: .delete) { (result: Result<Site, ApiError>) in
            switch result {
            case .success, .failure:
                alertItem = AlertItem(title: "alert_success_title", message: "alert_success_delete_site", action: dismissView)
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("section_header_builds")
            Spacer()
            if case let .success(value) = deploysLoadingState, value.count >= 5 {
                NavigationLink(destination: DeploysList(site: site)) {
                    Text("section_header_button_builds")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    var body: some View {
        Form {
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
            Section {
                Link(destination: site.adminUrl) {
                    Label("button_admin_panel", systemImage: "wrench.and.screwdriver.fill")
                }
            }
            Section(header: Text("section_header_about_site")) {
                Label(site.createdAt.siteDate, systemImage: "clock.arrow.circlepath")
                Label(site.updatedAt.siteDate, systemImage: "clock.arrow.2.circlepath")
                Label(site.accountName, systemImage: "person.2.fill")
                Label(site.accountType, systemImage: "dollarsign.circle.fill")
            }
            Section(header: Text("section_header_build_settings")) {
                if let repoBranch = site.buildSettings.repoBranch {
                    Label(repoBranch, systemImage: "arrow.triangle.branch")
                }
                if let repoUrl = site.buildSettings.repoUrl, let repoPath = site.buildSettings.repoPath {
                    Link(destination: repoUrl) {
                        Label(repoPath, systemImage: "tray.2.fill")
                    }
                }
                Label(site.buildImage, systemImage: "pc")
                if let cmd = site.buildSettings.cmd {
                    Label(cmd, systemImage: "terminal.fill")
                }
                if let dir = site.buildSettings.dir {
                    Label(dir, systemImage: "folder.fill")
                }
                if !site.plugins.isEmpty {
                    NavigationLink(destination: PluginsView(plugins: site.plugins)) {
                        Label("button_title_plugins", systemImage: "square.stack.3d.down.right.fill")
                    }
                }
                if !site.buildSettings.env.isEmpty {
                    NavigationLink(destination: EnvView(env: site.buildSettings.env)) {
                        Label("button_title_env", systemImage: "tray.full.fill")
                    }
                }
            }
            Section(header: header) {
                LoadingView(
                    loadingState: $deploysLoadingState,
                    load: listSiteDeploys
                ) { deploys in
                    List {
                        ForEach(deploys, id: \.id, content: DeployItems.init)
                    }
                }
            }
            Section {
                Button(action: { showActionSheet = true }) {
                    Label("button_delete_site", systemImage: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
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
}
