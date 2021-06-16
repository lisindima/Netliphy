//
//  DeploysViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.06.2021.
//

import SwiftUI

@MainActor
class DeploysViewModel: ObservableObject {
    @Published private(set) var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 10))
    
    func load(_ siteId: String) async {
        do {
            let value: [Deploy] = try await Loader.shared.fetch(.deploys(siteId: siteId))
            deploysLoadingState = .success(value)
        } catch {
            deploysLoadingState = .failure(error)
        }
    }
}
