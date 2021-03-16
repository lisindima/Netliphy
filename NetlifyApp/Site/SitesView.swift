//
//  SitesView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Kingfisher
import SwiftUI

struct SitesView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    var body: some View {
        NavigationView {
            LoadingView(
                loadingState: $sessionStore.sitesLoadingState,
                title: "dd",
                subTitle: "eee",
                load: sessionStore.listSites
            ) { sites in
                List {
                    ForEach(sites, id: \.id) { site in
                        SiteItems(site: site)
                    }
                }
            }
            .navigationTitle("navigation_title_sites")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: ProfileView()) {
                        if let avatarUrl = sessionStore.user?.avatarUrl {
                            KFImage(avatarUrl)
                                .resizable()
                                .placeholder { ProgressView() }
                                .frame(width: 30, height: 30)
                                .mask(Circle())
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: sessionStore.getCurrentUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SitesView()
    }
}
