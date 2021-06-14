//
//  AuthStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import Combine
import SwiftUI
import AuthenticationServices

class AuthStore: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    private var subscriptions: [AnyCancellable] = []
    
    func signIn() {
        let signInPromise = Future<URL, Error> { completion in
            let authSession = ASWebAuthenticationSession(url: .authURL, callbackURLScheme: .callbackURLScheme) { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = false
            authSession.start()
        }
        
        signInPromise.sink { completion in
            switch completion {
            case let .failure(error):
                print("auth failed for reason: \(error)")
            default: break
            }
        } receiveValue: { [self] url in
            accessToken = url.accessToken
        }
        .store(in: &subscriptions)
    }
    
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
