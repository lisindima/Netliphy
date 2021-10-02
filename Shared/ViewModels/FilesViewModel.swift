//
//  FilesViewModel.swift
//  FilesViewModel
//
//  Created by Дмитрий on 01.09.2021.
//

import SwiftUI

@MainActor
class FilesViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[File]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[File]>(filename: "netliphy_files")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        if let cachedFiles = await cache.value(forKey: siteId) {
            loadingState = .success(cachedFiles)
        }
        
        do {
            let value: [File] = try await Loader.shared.fetch(for: .files(siteId))
            if Task.isCancelled { return }
            
            await cache.setValue(value, forKey: siteId)
            try? await cache.saveToDisk()
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("files", error)
        }
    }
}
