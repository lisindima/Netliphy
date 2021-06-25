//
//  ProfileView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = TeamsViewModel()
    
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    var body: some View {
        List {
            if let user = accounts.first?.user {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            AsyncImage(url: user.avatarUrl) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .mask(Circle())
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                            }
                            if let fullName = user.fullName {
                                Text(fullName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            if let email = user.email {
                                Text(email)
                                    .font(.footnote)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            Section {
                LoadingView(
                    loadingState: viewModel.teamsLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { teams in
                    ForEach(teams, id: \.id, content: TeamItems.init)
                }
                .task {
                    await viewModel.load()
                }
            }
            Section(footer: appVersion) {
                NavigationLink(destination: NewsView()) {
                    Label("news_title", systemImage: "newspaper")
                }
                NavigationLink(destination: AccountsView()) {
                    Label("Accounts", systemImage: "person.2")
                        .badge(accounts.count)
                }
            }
        }
        .navigationTitle("navigation_title_profile")
    }
    
    private var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("section_footer_app_version \(version) (\(build))")
    }
}
