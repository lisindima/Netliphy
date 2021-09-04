//
//  PluginsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.03.2021.
//

import SwiftUI

struct PluginsView: View {
    @StateObject private var viewModel = PluginsViewModel()
    
    let installedPlugins: [InstalledPlugins]
    
    var body: some View {
        LoadingView(viewModel.loadingState) { plugins in
            List {
                Section {
                    ForEach(plugins, content: PluginItems.init)
                }
            }
        }
        .navigationTitle("Plugins")
        .task {
            await viewModel.load(installedPlugins)
        }
    }
}
