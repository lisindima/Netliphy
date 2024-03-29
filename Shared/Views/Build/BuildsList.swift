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
    
    @AppStorage("selectedSlug", store: store) private var selectedSlug: String = ""
    
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
                    ForEach(filterBuilds(builds), content: BuildItems.init)
                }
                .refreshable {
                    await viewModel.load(selectedSlug)
                }
            }
        }
        .navigationTitle("Builds")
        .toolbar {
            Button {
                showFilter = true
            } label: {
                Label(filtersApplied ? "Filtered" : "Filter", systemImage: filtersApplied ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
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
            await viewModel.load(selectedSlug)
        }
    }
    
    private func filterBuilds(_ builds: [Build]) -> [Build] {
        builds
            .filter {
                switch buildStateFilter {
                case .allState:
                    return true
                case let .filteredByState(state):
                    return state == $0.state
                }
            }
            .filter {
                switch siteNameFilter {
                case .allSites:
                    return true
                case let .filteredBySite(site):
                    return site == $0.subdomain
                }
            }
            .filter {
                productionFilter ? $0.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        buildStateFilter != .allState || siteNameFilter != .allSites || productionFilter
    }
}
