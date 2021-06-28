//
//  LoginView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 05.03.2021.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AccountsViewModel()
    
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
            Text("Netliphy helps you manage sites hosted on Netlify. View site settings and build logs.")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Button("Login with Netlify") {
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
