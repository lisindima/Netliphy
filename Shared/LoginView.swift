//
//  LoginView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 05.03.2021.
//

import BetterSafariView
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var startingWebAuthenticationSession: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("netliphy")
                .resizable()
                .cornerRadius(25)
                .frame(width: 150, height: 150)
            Text("Netliphy")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("subtitle_login")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Button("button_login_netlify", action: { startingWebAuthenticationSession = true })
                .buttonStyle(CustomButtonStyle())
        }
        .webAuthenticationSession(isPresented: $startingWebAuthenticationSession) {
            WebAuthenticationSession(
                url: .authURL,
                callbackURLScheme: .callbackURLScheme,
                completionHandler: sessionStore.signIn
            )
            .prefersEphemeralWebBrowserSession(false)
        }
    }
}
