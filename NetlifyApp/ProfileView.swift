//
//  ProfileView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    private func quitAccount() {
        sessionStore.accessToken = ""
        sessionStore.user = nil
    }
    
    var header: some View {
        HStack {
            if let avatarUrl = sessionStore.user?.avatarUrl {
                KFImage(avatarUrl)
                    .resizable()
                    .placeholder { ProgressView() }
                    .loadImmediately()
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
            Label {
                Text(github)
            } icon: {
                Image("github")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        if let bitbucket = sessionStore.user?.connectedAccounts.bitbucket {
            Label(bitbucket, systemImage: "ladybug")
        }
        if let gitlab = sessionStore.user?.connectedAccounts.gitlab {
            Label(gitlab, systemImage: "ladybug")
        }
    }
    
    var body: some View {
        Form {
            header
            Section(header: Text("Подключенные аккаунты")) {
                connectedAccounts
            }
            Section {
                Button(action: quitAccount) {
                    Label("Выйти", systemImage: "xmark")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Профиль")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
