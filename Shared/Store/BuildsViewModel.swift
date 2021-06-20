//
//  BuildsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class BuildsViewModel: ObservableObject {
    @Published private(set) var buildsLoadingState: LoadingState<[Build]> = .loading(Array(repeating: .placeholder, count: 10))
    
    func load(_ slug: String) async {
        do {
            let value: [Build] = try await Loader.shared.fetch(.builds(slug))
            buildsLoadingState = .success(value)
        } catch {
            buildsLoadingState = .failure(error)
            print("listBuilds", error)
        }
    }
}
