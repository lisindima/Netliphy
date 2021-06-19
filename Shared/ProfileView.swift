//
//  ProfileView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @StateObject private var viewModel = TeamsViewModel()
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        AsyncImage(url: sessionStore.user?.avatarUrl) { image in
                            image
                                .resizable()
                                .frame(width: 150, height: 150)
                                .mask(Circle())
                            
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 150)
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
            }
            .padding(.vertical)
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
            Section {
                NavigationLink(destination: NewsView()) {
                    Label("news_title", systemImage: "newspaper")
                }
            }
            Section(footer: appVersion) {
                Button {
                    async {
                        sessionStore.signOut()
                    }
                } label: {
                    Label("button_quit_account", systemImage: "xmark")
                        .foregroundColor(.red)
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
