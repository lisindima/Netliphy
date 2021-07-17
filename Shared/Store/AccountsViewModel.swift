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
    
    private func getToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let authSession = ASWebAuthenticationSession(url: .authURL, callbackURLScheme: .callbackURLScheme) { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url.accessToken)
                }
            }
            
//            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = false
            authSession.start()
        }
    }
    
    private func getUser<T: Decodable>(
        _ endpoint: Endpoint,
        token: String
    ) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: createRequest(endpoint, token: "Bearer " + token, httpMethod: .get))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func signIn() async {
        do {
            let token = try await getToken()
            async let user: User = try await getUser(.user, token: token)
            async let teams: [Team] = try await Loader.shared.fetch(.accounts, token: token)
            let account = try await Account(
                user: user,
                teams: teams,
                token: token,
                typeToken: "Bearer"
            )
            accounts.append(account)
        } catch {
            print(error)
        }
    }
}

#if !os(watchOS)
extension AccountsViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
#endif
