//
//  FunctionViewModel.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

@MainActor
class FunctionViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<FunctionInfo> = .loading(.placeholder)
    
    private let cache = DiskCache<FunctionInfo>(filename: "netliphy_function")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        if let cachedFunction = await cache.value(forKey: siteId) {
            loadingState = .success(cachedFunction)
        }
        
        do {
            let value: FunctionInfo = try await Loader.shared.fetch(for: .functions(siteId))
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
