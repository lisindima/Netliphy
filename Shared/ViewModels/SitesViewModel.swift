//
//  SitesViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.06.2021.
//

import SwiftUI

@MainActor
class SitesViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Site]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[Site]>(filename: "sites", expirationInterval: 1 * 60)
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load() async {
        if Task.isCancelled { return }
        
        if let cachedSite = await cache.value(forKey: "sites") {
            loadingState = .success(cachedSite)
            print("CACHED")
        }
        
        do {
            let value: [Site] = try await Loader.shared.fetch(for: .sites)
            if Task.isCancelled { return }
            await cache.setValue(value, forKey: "sites")
            try? await cache.saveToDisk()
            print("CACHE SET")
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("listSites", error)
        }
    }
}
