//
//  AccountsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import AuthenticationServices
import SwiftUI

@MainActor
class AccountsViewModel: NSObject, ObservableObject {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    @AppStorage("selectedSlug", store: store) private var selectedSlug: String = ""
    
    private func getToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let authSession = ASWebAuthenticationSession(url: .authURL, callbackURLScheme: .callbackURLScheme) { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url.accessToken)
                }
            }
            
            #if !os(watchOS)
            authSession.presentationContextProvider = self
            #endif
            
            authSession.prefersEphemeralWebBrowserSession = false
            authSession.start()
        }
    }
    
    func signIn() async {
        do {
            let token = try await getToken()
            async let user: User = try Loader.shared.fetch(.user, token: token)
            async let teams: [Team] = try Loader.shared.fetch(.accounts, token: token)
            let account = try await Account(
                user: user,
                teams: teams,
                token: token,
                type: "Bearer"
            )
            
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

#if !os(watchOS)
extension AccountsViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
#endif
