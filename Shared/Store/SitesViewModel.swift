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
    
    func load() async {
        if Task.isCancelled { return }
        do {
            let value: [Site] = try await Loader.shared.fetch(for: .sites)
            if Task.isCancelled { return }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("listSites", error)
        }
    }
}
