//
//  SiteViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<SiteLoader> = .loading(.placeholder)
    
    private let cache = DiskCache<SiteLoader>(filename: "netliphy_site")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        if let cachedSite = await cache.value(forKey: siteId) {
            loadingState = .success(cachedSite)
        }
        
        do {
            async let deploys: [Deploy] = try Loader.shared.fetch(for: .deploys(siteId, items: 5))
            async let forms: [SiteForm] = try Loader.shared.fetch(for: .forms(siteId))
            async let functions: FunctionInfo? = try? Loader.shared.fetch(for: .functions(siteId))
            let siteLoader: SiteLoader = try await SiteLoader(deploys: deploys, forms: forms, functions: functions)
            if Task.isCancelled { return }
            
            await cache.setValue(siteLoader, forKey: siteId)
            try? await cache.saveToDisk()
            
            loadingState = .success(siteLoader)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print(error)
        }
    }
}
