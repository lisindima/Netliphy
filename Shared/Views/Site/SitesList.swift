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
        LoadingView(viewModel.loadingState) { sites in
            List {
                ForEach(searchSite(sites), content: SiteItems.init)
            }
            .searchable(text: $query)
            .refreshable {
                await viewModel.load()
            }
        }
        .navigationTitle("Sites")
        .task {
            await viewModel.load()
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
