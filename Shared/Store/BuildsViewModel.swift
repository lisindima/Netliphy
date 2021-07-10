//
//  BuildsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class BuildsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Build]> = .loading(.arrayPlaceholder)
    
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    func load() async {
        do {
            let value: [Build] = try await Loader.shared.fetch(.builds(accounts.first?.teams.first?.slug ?? ""))
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.arrayPlaceholder, error: error)
            print("listBuilds", error)
        }
    }
}
