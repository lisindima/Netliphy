//
//  LoginView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 05.03.2021.
//

import SwiftUI
import BetterSafariView

struct LoginView: View {
    @State private var startingWebAuthenticationSession: Bool = false
    
    private let url = URL(string: "https://app.netlify.com/authorize?response_type=token&client_id=g3HY3QeZegSC-qbJby-6wEXjJQBm1kDSWQuWTE52a1s&redirect_uri=https://netlifyhub://callback")!
    private let callbackURLScheme = "netlifyhub"
    
    private func openWebAuthenticationSession() {
        startingWebAuthenticationSession = true
    }
    
    var body: some View {
        Button("Войти c помощью Netlify", action: openWebAuthenticationSession)
            .buttonStyle(CustomButtonStyle())
            .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
                WebAuthenticationSession(
                    url: url,
                    callbackURLScheme: callbackURLScheme
                ) { callbackURL, error in
                    print(callbackURL as Any)
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
