//
//  ProfileView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var sessionStore: SessionStore
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var header: some View {
        HStack {
            if let avatarUrl = sessionStore.user?.avatarUrl {
                KFImage(avatarUrl)
                    .resizable()
                    .placeholder { ProgressView() }
                    .frame(width: 100, height: 100)
                    .mask(Circle())
            }
            Spacer()
            VStack(alignment: .leading) {
                if let fullName = sessionStore.user?.fullName {
                    Text(fullName)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                if let email = sessionStore.user?.email {
                    Text(email)
                        .font(.footnote)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    var connectedAccounts: some View {
        if let github = sessionStore.user?.connectedAccounts.github {
            Label(github, systemImage: "ladybug")
        }
        if let bitbucket = sessionStore.user?.connectedAccounts.bitbucket {
            Label(bitbucket, systemImage: "ladybug")
        }
        if let gitlab = sessionStore.user?.connectedAccounts.gitlab {
            Label(gitlab, systemImage: "ladybug")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                header
                Section(header: Text("Подключенные аккаунты")) {
                    connectedAccounts
                }
                Section {
                    Button("Выйти", action: {})
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Профиль")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: dismissView) {
                        Label("Закрыть", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
