//
//  ProfileView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) @Binding private var presentationMode
    
    @EnvironmentObject private var sessionStore: SessionStore
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if let avatarUrl = sessionStore.user?.avatarUrl {
                            KFImage(avatarUrl)
                                .resizable()
                                .placeholder { ProgressView() }
                                .loadImmediately()
                                .frame(width: 150, height: 150)
                                .mask(Circle())
                        }
                        if let fullName = sessionStore.user?.fullName {
                            Text(fullName)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        if let email = sessionStore.user?.email {
                            Text(email)
                                .font(.footnote)
                        }
                        AccountItems(connectedAccounts: sessionStore.user?.connectedAccounts)
                    }
                    Spacer()
                }
            }
            .padding(.vertical)
            Section {
                LoadingView(
                    loadingState: $sessionStore.teamsLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { teams in
                    ForEach(teams, id: \.id, content: TeamItems.init)
                }
                .onAppear(perform: sessionStore.listAccountsForUser)
            }
            Section {
                NavigationLink(destination: NewsView()) {
                    Label("news_title", systemImage: "newspaper")
                }
            }
            Section(footer: appVersion) {
                Button(action: sessionStore.signOut) {
                    Label("button_quit_account", systemImage: "xmark")
                        .foregroundColor(.red)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("navigation_title_profile")
    }
    
    private var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("section_footer_app_version \(version) (\(build))")
    }
}

struct AccountItems: View {
    let connectedAccounts: ConnectedAccounts?
    
    var body: some View {
        if let accounts = connectedAccounts {
            HStack {
                if accounts.github != nil {
                    Image("github")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                if accounts.bitbucket != nil {
                    Image("bitbucket")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                if accounts.gitlab != nil {
                    Image("gitlab")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}
