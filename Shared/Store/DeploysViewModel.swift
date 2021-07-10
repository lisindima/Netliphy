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
    
    func load(_ siteId: String) async {
        do {
            let value: [Deploy] = try await Loader.shared.fetch(.deploys(siteId))
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.arrayPlaceholder, error: error)
        }
    }
}
