//
//  FormViewModel.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[SiteForm]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[SiteForm]>(filename: "netliphy_form")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        if let cachedForm = await cache.value(forKey: siteId) {
            loadingState = .success(cachedForm)
        }
        
        do {
            let value: [SiteForm] = try await Loader.shared.fetch(for: .forms(siteId))
            if Task.isCancelled { return }
            
            await cache.setValue(value, forKey: siteId)
            try? await cache.saveToDisk()
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("listFunctions", error)
        }
    }
}
