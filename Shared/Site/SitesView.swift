//
//  SitesView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI
import Kingfisher

struct SitesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var showProfileView: Bool = false
    @State private var showDeploy: Bool = false
    
    @ViewBuilder
    var navigationItems: some View {
        if let avatarUrl = sessionStore.user?.avatarUrl {
            Button(action: { showProfileView = true }) {
                KFImage(avatarUrl)
                    .resizable()
                    .placeholder { ProgressView() }
                    .loadImmediately()
                    .frame(width: 30, height: 30)
                    .mask(Circle())
            }
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.sitesLoadingState,
            empty: EmptyStateView(
                title: "title_empty_site_list",
                subTitle: "subTitle_empty_site_list"
            ),
            failure: { error in
                FailureView(error.localizedDescription, action: sessionStore.listSites)
            }
        ) { sites in
            List {
                ForEach(sites, id: \.id, content: SiteItems.init)
            }
        }
        .onAppear(perform: sessionStore.listSites)
        .navigationTitle("navigation_title_sites")
        .navigationBarItems(trailing: navigationItems)
        .sheet(isPresented: $showProfileView) {
            NavigationView {
                ProfileView()
                    .environmentObject(sessionStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear(perform: sessionStore.getCurrentUser)
        .onOpenURL { url in
            print(url)
        }
        .fullScreenCover(isPresented: $showDeploy) {
            DeployDetails(deploy: .placeholder)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SitesView()
    }
}
