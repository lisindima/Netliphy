//
//  LoginView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 05.03.2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
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
            Button("button_login_netlify") {
                async {
                    await viewModel.signIn()
                }
            }
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .buttonStyle(.bordered)
            .controlSize(.large)
            .controlProminence(.increased)
        }
    }
}
