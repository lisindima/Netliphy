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
    @Environment(\.colorScheme) private var colorScheme
    
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var teamsLoadingState: LoadingState<[Team]> = .loading
    
    private func quitAccount() {
        presentationMode.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sessionStore.accessToken = ""
            sessionStore.user = nil
        }
    }
    
    private func listAccountsForUser() {
        Endpoint.api.fetch(.accounts) { (result: Result<[Team], ApiError>) in
            switch result {
            case let .success(value):
                teamsLoadingState = .success(value)
            case let .failure(error):
                teamsLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    private var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("section_footer_app_version \(version) (\(build))")
    }
    
    var body: some View {
        Form {
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
                }
                Spacer()
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(
                colorScheme == .light
                    ? Color(.secondarySystemBackground)
                    : Color(.systemBackground)
            )
            Section(header: Text("section_header_teams")) {
                LoadingView(
                    loadingState: $teamsLoadingState,
                    load: listAccountsForUser
                ) { teams in
                    ForEach(teams, id: \.id, content: TeamItems.init)
                }
            }
            if let accounts = sessionStore.user?.connectedAccounts {
                Section(header: Text("section_header_connected_accounts")) {
                    if let github = accounts.github {
                        AccountItem(github, image: "github")
                    }
                    if let bitbucket = accounts.bitbucket {
                        AccountItem(bitbucket, image: "bitbucket")
                    }
                    if let gitlab = accounts.gitlab {
                        AccountItem(gitlab, image: "gitlab")
                    }
                }
            }
            Section(footer: appVersion) {
                Button(action: quitAccount) {
                    Label("button_quit_account", systemImage: "xmark")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("navigation_title_profile")
    }
}

struct AccountItem: View {
    var title: String
    var image: String
    
    init(_ title: String, image: String) {
        self.title = title
        self.image = image
    }
    
    var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
}
