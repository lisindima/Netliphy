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
        do {
            let value: [Site] = try await Loader.shared.fetch(.sites)
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.arrayPlaceholder, error: error)
            print("listSites", error)
        }
    }
}
