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
    @State private var stateFilter: BuildStateFilter = .allState
    @State private var productionFilter: Bool = false
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.buildsLoadingState,
            empty: EmptyStateView(
                title: "title_empty_site_list",
                subTitle: "subTitle_empty_site_list"
            ),
            failure: { error in
                FailureView(error.localizedDescription, action: sessionStore.listBuilds)
            }
        ) { builds in
            List {
                ForEach(filterBuilds(builds), id: \.id, content: BuildItems.init)
            }
        }
        .navigationTitle("Builds")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showFilter = true }) {
                    Image(systemName: filtersApplied
                            ? "line.horizontal.3.decrease.circle.fill"
                            : "line.horizontal.3.decrease.circle"
                    )
                }
                .unredacted()
            }
        }
        .sheet(isPresented: $showFilter) {
            BuildsFilterView(
                stateFilter: $stateFilter,
                productionFilter: $productionFilter
            )
        }
        .onAppear(perform: sessionStore.listBuilds)
    }
    
    func filterBuilds(_ builds: [Build]) -> [Build] {
        return builds
            .filter { build -> Bool in
                switch self.stateFilter {
                case .allState:
                    return true
                case let .filteredByState(state):
                    return state == build.state
                }
            }
            .filter { build -> Bool in
                return productionFilter ? build.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        stateFilter != .allState || productionFilter
    }
}
