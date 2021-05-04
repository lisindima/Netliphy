//
//  SitesList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

struct SitesList: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
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
        .onAppear(perform: sessionStore.listSites)
    }
}
