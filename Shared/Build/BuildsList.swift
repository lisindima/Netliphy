//
//  BuildsList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildsList: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @State private var showFilter: Bool = false
    @State private var buildStateFilter: BuildStateFilter = .allState
    @State private var siteNameFilter: SiteNameFilter = .allSites
    @State private var productionFilter: Bool = false
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.buildsLoadingState,
            empty: EmptyStateView(
                title: "title_empty_builds_list",
                subTitle: "subTitle_empty_builds_list"
            ),
            failure: { error in
                FailureView(error.localizedDescription, action: sessionStore.listBuilds)
            }
        ) { builds in
            List {
                ForEach(filterBuilds(builds), id: \.id, content: BuildItems.init)
            }
        }
        .navigationTitle("navigation_title_builds")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showFilter = true }) {
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
        .onAppear(perform: sessionStore.listBuilds)
    }
    
    private func filterBuilds(_ builds: [Build]) -> [Build] {
        return builds
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
                return productionFilter ? build.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        buildStateFilter != .allState || siteNameFilter != .allSites || productionFilter
    }
}
