//
//  SitesList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

struct SitesList: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var query: String = ""
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.sitesLoadingState,
            empty: EmptyStateView(
                title: "title_empty_site_list",
                subTitle: "subTitle_empty_site_list"
            ),
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { sites in
            List {
                ForEach(searchSite(sites), id: \.id, content: SiteItems.init)
            }
            .searchable("Search sites", text: $query, placement: .automatic)
            .refreshable {
                await sessionStore.listSites()
            }
        }
        .navigationTitle("navigation_title_sites")
        .onAppear {
            async {
                await sessionStore.listSites()
            }
        }
    }
    
    private func searchSite(_ sites: [Site]) -> [Site] {
        if query.isEmpty {
            return sites
        } else {
            return sites.filter {
                $0.name.hasPrefix(query)
            }
        }
    }
}
