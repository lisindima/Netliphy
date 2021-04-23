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
    private var navigationProfile: some View {
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
    
    private var navigationDeploy: some View {
        Button(action: { showDeploy = false }) {
            ExitButtonView()
        }
        .frame(width: 30, height: 30)
    }
    
    private func presentDeploy(_ url: URL) {
        print(url["deployId"])
        showDeploy = true
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
        .navigationTitle("navigation_title_sites")
        .navigationBarItems(trailing: navigationProfile)
        .sheet(isPresented: $showProfileView) {
            NavigationView {
                ProfileView()
                    .environmentObject(sessionStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .sheet(isPresented: $showDeploy) {
            NavigationView {
                DeployDetails(deployId: "607e2ac618645700071905a0")
                    .navigationBarItems(trailing: navigationDeploy)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear(perform: sessionStore.listSites)
        .onAppear(perform: sessionStore.getCurrentUser)
        .onOpenURL(perform: presentDeploy)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SitesView()
    }
}
