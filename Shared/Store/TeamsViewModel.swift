//
//  TeamsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 18.06.2021.
//

import SwiftUI

@MainActor
class TeamsViewModel: ObservableObject {
    @Published private(set) var teamsLoadingState: LoadingState<[Team]> = .loading(Array(repeating: .placeholder, count: 1))
    
    func load() async {
        do {
            let value: [Team] = try await Loader.shared.fetch(.accounts)
            teamsLoadingState = .success(value)
        } catch {
            teamsLoadingState = .failure(error)
            print("listAccountsForUser", error)
        }
    }
}
