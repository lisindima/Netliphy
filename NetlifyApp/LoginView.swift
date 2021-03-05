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
    
    private func openWebAuthenticationSession() {
        startingWebAuthenticationSession = true
    }
    
    var body: some View {
        Button("Войти", action: openWebAuthenticationSession)
            .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
                WebAuthenticationSession(
                    url: URL(string: "https://app.netlify.com/authorize?response_type=token&client_id=g3HY3QeZegSC-qbJby-6wEXjJQBm1kDSWQuWTE52a1s&redirect_uri=netlifyhub://authentication")!,
                    callbackURLScheme: "netlifyhub"
                ) { callbackURL, error in
                    print(callbackURL)
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
