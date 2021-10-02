//
//  BuildsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class BuildsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Build]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[Build]>(filename: "netliphy_builds")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ slug: String) async {
        if Task.isCancelled { return }
        
        if let cachedBuilds = await cache.value(forKey: slug) {
            loadingState = .success(cachedBuilds)
        }
        
        do {
            let value: [Build] = try await Loader.shared.fetch(for: .builds(slug))
            if Task.isCancelled { return }
            
            await cache.setValue(value, forKey: slug)
            try? await cache.saveToDisk()
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("listBuilds", error)
        }
    }
}
