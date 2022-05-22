//
//  FilesViewModel.swift
//  FilesViewModel
//
//  Created by Дмитрий on 01.09.2021.
//

import SwiftUI

@MainActor
class FilesViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[File]> = .placeholder(.arrayPlaceholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        do {
            let value: [File] = try await Loader.shared.fetch(for: .files(siteId))
            if Task.isCancelled { return }
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("files", error)
        }
    }
}
