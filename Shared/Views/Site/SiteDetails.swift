//
//  SiteDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct SiteDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var viewModel: SitesViewModel
    
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
                NavigationLink {
                    DeploysList(siteId: site.id)
                } label: {
                    SiteMenuItems(
                        title: "Deploys",
                        message: "Deploys",
                        systemImage: "bolt.fill"
                    )
                }
                NavigationLink {
                    PluginsView(installedPlugins: site.plugins, siteId: site.id)
                } label: {
                    SiteMenuItems(
                        title: "Plugins",
                        message: "In one click, add powerful features to your build workflow with community Build Plugins.",
                        systemImage: "square.stack.3d.down.right.fill"
                    )
                }
                if site.capabilities.functions != nil {
                    NavigationLink {
                        FunctionList(siteId: site.id)
                    } label: {
                        SiteMenuItems(
                            title: "Functions",
                            message: "Write serverless functions that are version-controlled, built, and deployed along with the rest of your Netlify site.",
                            systemImage: "square.stack.3d.down.right.fill"
                        )
                    }
                }
                if site.capabilities.forms != nil {
                    NavigationLink {
                        FormList(siteId: site.id)
                    } label: {
                        SiteMenuItems(
                            title: "Forms",
                            message: "Manage forms and submissions without any server-side code or JavaScript.",
                            systemImage: "square.stack.3d.down.right.fill"
                        )
                    }
                }
                NavigationLink {
                    EnvView(env: site.buildSettings.env, siteId: site.id)
                } label: {
                    SiteMenuItems(
                        title: "Environment variables",
                        message: "Set environment variables for your build script and add-ons.",
                        systemImage: "tray.full.fill"
                    )
                }
                NavigationLink {
                    NotificationsView(siteId: site.id, forms: site.capabilities.forms)
                } label: {
                    SiteMenuItems(
                        title: "Deploy notifications",
                        message: "Turn on notifications to monitor your site's deployment",
                        systemImage: "bell.badge.fill"
                    )
                }
                NavigationLink {
                    FilesList(siteId: site.id)
                } label: {
                    SiteMenuItems(
                        title: "Files",
                        message: "Files",
                        systemImage: "doc.on.doc.fill"
                    )
                }
            }
        }
        .navigationTitle(site.name)
        .refreshable {
            await viewModel.load()
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
                        Label("Open site", systemImage: "safari.fill")
                    }
                }
                Section {
                    Link(destination: site.adminUrl) {
                        Label("Open admin console", systemImage: "display")
                    }
                    if let repoUrl = site.buildSettings.repoUrl {
                        Link(destination: repoUrl) {
                            Label("Open repository", systemImage: "rectangle.stack.fill")
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
                Label("Open menu", systemImage: "ellipsis")
            }
        }
        .task {
            await viewModel.load()
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

struct SiteMenuItems: View {
    let title: String
    let message: String
    let systemImage: String
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                Text(message)
                    .font(.footnote)
            }
        } icon: {
            Image(systemName: systemImage)
                .font(.body.weight(.bold))
        }
    }
}
