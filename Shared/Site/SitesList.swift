//
//  SitesList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

struct SitesList: View {
    @EnvironmentObject private var viewModel: SitesViewModel
    
    @State private var query: String = ""
    
    var body: some View {
        LoadingView(
            loadingState: viewModel.sitesLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { sites in
            List {
                ForEach(searchSite(sites), id: \.id, content: SiteItems.init)
            }
            .searchable("Search sites", text: $query, placement: .automatic)
            .refreshable {
                await viewModel.load()
            }
        }
        .navigationTitle("navigation_title_sites")
        .task {
            async {
                await viewModel.load()
            }
        }
    }
    
    private func searchSite(_ sites: [Site]) -> [Site] {
        if query.isEmpty {
            return sites
        } else {
            return sites.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
    }
}
