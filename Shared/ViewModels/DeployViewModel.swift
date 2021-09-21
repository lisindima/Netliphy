//
//  DeployViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class DeployViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<DeployLoader> = .loading(.placeholder)
    
    private let cache = DiskCache<DeployLoader>(filename: "netliphy_deploy")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ deployId: String) async {
        if Task.isCancelled { return }
        
        if let cachedDeploy = await cache.value(forKey: deployId) {
            loadingState = .success(cachedDeploy)
            print("CACHED")
        }
        
        do {
            async let deploy: Deploy = try await Loader.shared.fetch(for: .deploy(deployId))
            async let pluginRun: [PluginRun] = try await Loader.shared.fetch(for: .pluginRuns(deployId))
            async let eventDeploy: [EventDeploy]? = try? await Loader.shared.fetch(for: .eventDeploy(deployId))
            let site: Site = try await Loader.shared.fetch(for: .site(deploy.siteId))
            let deployLoader = try await DeployLoader(deploy: deploy, site: site, pluginRun: pluginRun, eventDeploy: eventDeploy)
            if Task.isCancelled { return }
            
            await cache.setValue(deployLoader, forKey: deployId)
            try? await cache.saveToDisk()
            print("CACHE SET")
            
            loadingState = .success(deployLoader)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print(error)
        }
    }
}
