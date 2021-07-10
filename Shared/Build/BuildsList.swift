//
//  BuildsList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildsList: View {
    @StateObject private var viewModel = BuildsViewModel()
    
    @State private var showFilter: Bool = false
    @State private var buildStateFilter: BuildStateFilter = .allState
    @State private var siteNameFilter: SiteNameFilter = .allSites
    @State private var productionFilter: Bool = false
    
    var body: some View {
        LoadingView(viewModel.loadingState) { builds in
            if let filteredBuilds = filterBuilds(builds), filteredBuilds.isEmpty {
                VStack(spacing: 5) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.largeTitle)
                    Text("No builds")
                        .fontWeight(.bold)
                }
                .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(filterBuilds(builds), id: \.id, content: BuildItems.init)
                }
                .refreshable {
                    await viewModel.load()
                }
            }
        }
        .navigationTitle("Builds")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showFilter = true
                } label: {
                    Image(systemName: filtersApplied
                          ? "line.horizontal.3.decrease.circle.fill"
                          : "line.horizontal.3.decrease.circle"
                    )
                }
            }
        }
        .sheet(isPresented: $showFilter) {
            BuildsFilterView(
                buildStateFilter: $buildStateFilter,
                siteNameFilter: $siteNameFilter,
                productionFilter: $productionFilter
            )
        }
        .task {
            async {
                await viewModel.load()
            }
        }
    }
    
    private func filterBuilds(_ builds: [Build]) -> [Build] {
        builds
            .filter { build -> Bool in
                switch buildStateFilter {
                case .allState:
                    return true
                case let .filteredByState(state):
                    return state == build.state
                }
            }
            .filter { build -> Bool in
                switch siteNameFilter {
                case .allSites:
                    return true
                case let .filteredBySite(site):
                    return site == build.subdomain
                }
            }
            .filter { build -> Bool in
                productionFilter ? build.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        buildStateFilter != .allState || siteNameFilter != .allSites || productionFilter
    }
}
