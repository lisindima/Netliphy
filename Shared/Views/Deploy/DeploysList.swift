//
//  DeploysList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 10.03.2021.
//

import SwiftUI

struct DeploysList: View {
    @StateObject private var viewModel = DeploysViewModel()
    
    @State private var showFilter: Bool = false
    @State private var stateFilter: DeployStateFilter = .allState
    @State private var productionFilter: Bool = false
    
    let siteId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { deploys in
            if let filteredDeploys = filterDeploys(deploys), filteredDeploys.isEmpty {
                VStack(spacing: 5) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.largeTitle)
                    Text("No deploys")
                        .fontWeight(.bold)
                }
                .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(filterDeploys(deploys), id: \.id, content: DeployItems.init)
                }
                .refreshable {
                    await viewModel.load(siteId)
                }
            }
        }
        .navigationTitle("Deploys")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showFilter = true
                } label: {
                    Label(filtersApplied ? "Filtered" : "Filter", systemImage: filtersApplied ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showFilter) {
            DeploysFilterView(
                stateFilter: $stateFilter,
                productionFilter: $productionFilter
            )
        }
        .task {
            await viewModel.load(siteId)
        }
    }
    
    private func filterDeploys(_ deploys: [Deploy]) -> [Deploy] {
        deploys
            .filter { deploy -> Bool in
                switch stateFilter {
                case .allState:
                    return true
                case let .filteredByState(state):
                    return state == deploy.state
                }
            }
            .filter { deploy -> Bool in
                productionFilter ? deploy.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        stateFilter != .allState || productionFilter
    }
}
