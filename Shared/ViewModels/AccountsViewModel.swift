//
//  AccountsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import SwiftUI

@MainActor
class AccountsViewModel: ObservableObject {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    @AppStorage("selectedSlug", store: store) private var selectedSlug: String = ""
    
    let controller = AuthController()
    
    func signIn() async {
        do {
            let token = try await controller.authenticationUser()
            async let user: User = try Loader.shared.fetch(for: .user, token: "Bearer " + token)
            async let teams: [Team] = try Loader.shared.fetch(for: .accounts, token: "Bearer " + token)
            let account = try await Account(user: user, teams: teams, token: token)
            
            accounts.insert(account, at: 0)
            
            if let teamName = account.teams.first?.slug {
                selectedSlug = teamName
            }
        } catch {
            print(error)
        }
    }
    
    func select(_ account: Account) {
        guard let index = accounts.firstIndex(where: { $0.id == account.id }) else { return }
        accounts.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
    }
    
    func delete(_ account: Account) {
        guard let index = accounts.firstIndex(where: { $0.id == account.id }) else { return }
        accounts.remove(at: index)
    }
}
