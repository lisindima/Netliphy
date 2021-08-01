//
//  LoginView.swift
//  Netliphy (watchOS) Extension
//
//  Created by Дмитрий Лисин on 17.07.2021.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AccountsViewModel()
    
    var body: some View {
        VStack {
            Text("Netliphy")
                .font(.title2)
                .fontWeight(.bold)
            Text("Netliphy helps you manage sites hosted on Netlify. View site settings and build logs.")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                Label("Sign in with Netlify", systemImage: "diamond.fill")
                    .font(.footnote)
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
