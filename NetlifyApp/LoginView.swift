//
//  LoginView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 05.03.2021.
//

import SwiftUI
import BetterSafariView

struct LoginView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var startingWebAuthenticationSession: Bool = false
    
    private let url = URL(string: "https://app.netlify.com/authorize?response_type=token&client_id=g3HY3QeZegSC-qbJby-6wEXjJQBm1kDSWQuWTE52a1s&redirect_uri=https://cutt.ly/CzWICkG")!
    private let callbackURLScheme = "netlifyhub"
    
    private func openWebAuthenticationSession() {
        startingWebAuthenticationSession = true
    }
    
    var body: some View {
        VStack {
            Spacer()
            Button("Войти c помощью Netlify", action: openWebAuthenticationSession)
                .buttonStyle(CustomButtonStyle())
        }
        .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
            WebAuthenticationSession(
                url: url,
                callbackURLScheme: callbackURLScheme
            ) { callbackURL, error in
                guard let url = callbackURL else { return }
                sessionStore.accessToken = url.getAccessToken()
            }
            .prefersEphemeralWebBrowserSession(false)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
