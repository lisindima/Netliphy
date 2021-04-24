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
    @State private var sheetItem: SheetItem?
    
    private var navigationProfile: some View {
        Button(action: { showProfileView = true }) {
            KFImage(sessionStore.user?.avatarUrl)
                .resizable()
                .placeholder { ProgressView() }
                .loadImmediately()
                .frame(width: 30, height: 30)
                .mask(Circle())
        }
    }
    
    private var navigationDeploy: some View {
        Button(action: { sheetItem = nil }) {
            ExitButtonView()
        }
        .frame(width: 30, height: 30)
    }
    
    private func presentDeploy(_ url: URL) {
        guard let id = url["deployId"] else { return }
        sheetItem = SheetItem(id: id)
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
        .sheet(item: $sheetItem) { item in
            NavigationView {
                DeployDetails(deployId: item.id)
                    .navigationBarItems(trailing: navigationDeploy)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear(perform: sessionStore.listSites)
        .onAppear(perform: sessionStore.getCurrentUser)
        .onOpenURL(perform: presentDeploy)
    }
}

struct SheetItem: Identifiable {
    let id: String
}
