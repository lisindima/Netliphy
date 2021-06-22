//
//  AuthViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import AuthenticationServices
import SwiftUI

class AuthViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    func signIn() async throws -> String  {
        try await withCheckedThrowingContinuation { continuation in
            let authSession = ASWebAuthenticationSession(url: .authURL, callbackURLScheme: .callbackURLScheme) { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url.accessToken)
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = false
            authSession.start()
        }
    }
    
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
