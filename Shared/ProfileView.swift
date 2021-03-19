//
//  ProfileView.swift
//  Netliphy
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
    
    var body: some View {
        Form {
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
            if let accounts = sessionStore.user?.connectedAccounts {
                Section(header: Text("section_header_connected_accounts")) {
                    if let github = accounts.github {
                        AccountItem(name: github, imageName: "github")
                    }
                    if let bitbucket = accounts.bitbucket {
                        AccountItem(name: bitbucket, imageName: "bitbucket")
                    }
                    if let gitlab = accounts.gitlab {
                        AccountItem(name: gitlab, imageName: "gitlab")
                    }
                }
            }
            Section {
                Button(action: quitAccount) {
                    Label("button_quit_account", systemImage: "xmark")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("navigation_title_profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct AccountItem: View {
    var name: String
    var imageName: String
    
    var body: some View {
        Label {
            Text(name)
        } icon: {
            Image(imageName)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
