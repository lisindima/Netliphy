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
        LoadingView(
            loadingState: viewModel.deploysLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { deploys in
            List {
                ForEach(filterDeploys(deploys), id: \.id, content: DeployItems.init)
            }
            .refreshable {
                await viewModel.load(siteId)
            }
        }
        .navigationTitle("navigation_title_deploys")
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
