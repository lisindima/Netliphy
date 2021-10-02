//
//  DeploysViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.06.2021.
//

import SwiftUI

@MainActor
class DeploysViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Deploy]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[Deploy]>(filename: "netliphy_deploys")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        if let cachedDeploys = await cache.value(forKey: siteId) {
            loadingState = .success(cachedDeploys)
        }
        
        do {
            let value: [Deploy] = try await Loader.shared.fetch(for: .deploys(siteId))
            if Task.isCancelled { return }
            
            await cache.setValue(value, forKey: siteId)
            try? await cache.saveToDisk()
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
        }
    }
}
