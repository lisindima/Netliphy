//
//  PluginsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.03.2021.
//

import SwiftUI

struct PluginsView: View {
    @EnvironmentObject private var sitesViewModel: SitesViewModel
    
    @StateObject private var viewModel = PluginsViewModel()
    
    @State private var install: [InstalledPlugins] = []
    @State private var query: String = ""
    
    let siteId: String
    
    init(installedPlugins: [InstalledPlugins], siteId: String) {
        install = installedPlugins
        self.siteId = siteId
    }
    
    var body: some View {
        LoadingView(viewModel.loadingState) { plugins in
            List {
                if !installedPlugins(plugins).isEmpty {
                    Section {
                        ForEach(installedPlugins(plugins)) { plugin in
                            PluginItems(plugin: plugin)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            deletePlugin(plugin: plugin, plugins: plugins)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    } header: {
                        Text("Installed plugins")
                    }
                }
                if !notInstalledPlugins(plugins).isEmpty {
                    Section {
                        ForEach(notInstalledPlugins(plugins)) { plugin in
                            PluginItems(plugin: plugin)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        withAnimation {
                                            installPlugin(plugin: plugin, plugins: plugins)
                                        }
                                    } label: {
                                        Label("Install", systemImage: "checkmark.circle")
                                    }
                                    .tint(.purple)
                                }
                        }
                    } header: {
                        Text("Not installed plugins")
                    }
                }
            }
            .searchable(text: $query)
        }
        .navigationTitle("Plugins")
        .task {
            await viewModel.load()
        }
    }
    
    private func updatePlugins() {
        let plugins = PluginsHelper(plugins: install)
        Task {
            await viewModel.updatePlugins(siteId, plugins: plugins)
            await sitesViewModel.load()
        }
    }
    
    private func deletePlugin(plugin: Plugin, plugins: [Plugin]) {
        guard let index = plugins.firstIndex(where: { $0.package == plugin.package }) else { return }
        guard let index = install.firstIndex(where: { $0.package == plugins[index].package }) else { return }
        install.remove(at: index)
        updatePlugins()
    }
    
    private func installPlugin(plugin: Plugin, plugins: [Plugin]) {
        guard let index = plugins.firstIndex(where: { $0.package == plugin.package }) else { return }
        let installedPlugins = InstalledPlugins(package: plugins[index].package, pinnedVersion: nil)
        install.append(installedPlugins)
        updatePlugins()
    }
    
    private func installedPlugins(_ plugins: [Plugin]) -> [Plugin] {
        plugins
            .filter { plugin -> Bool in
                install.contains(where: { $0.package == plugin.package })
            }
            .filter { plugin -> Bool in
                if query.isEmpty {
                    return true
                } else {
                    return plugin.package.lowercased().contains(query.lowercased())
                }
            }
    }
    
    private func notInstalledPlugins(_ plugins: [Plugin]) -> [Plugin] {
        plugins
            .filter { plugin -> Bool in
                !install.contains(where: { $0.package == plugin.package })
            }
            .filter { plugin -> Bool in
                if query.isEmpty {
                    return true
                } else {
                    return plugin.package.lowercased().contains(query.lowercased())
                }
            }
    }
}

struct PluginsHelper: Codable {
    let plugins: [InstalledPlugins]
}
