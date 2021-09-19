//
//  AuthController.swift
//  Netliphy
//
//  Created by Дмитрий on 17.09.2021.
//

import SwiftUI
import AuthenticationServices

class AuthController: NSObject, ASWebAuthenticationPresentationContextProviding {
    func authenticationUser() async throws -> String {
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
