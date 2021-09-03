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
                .padding(.bottom)
            Text("Netliphy helps you manage sites hosted on Netlify. View site settings and build logs.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                Label("Sign in with Netlify", systemImage: "diamond.fill")
                    .frame(maxWidth: .infinity)
            }
            .font(.body.bold())
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding()
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
