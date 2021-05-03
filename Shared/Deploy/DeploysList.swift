//
//  DeploysList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 10.03.2021.
//

import SwiftUI

struct DeploysList: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 10))
    @State private var showFilter: Bool = false
    @State private var stateFilter: DeployStateFilter = .allState
    @State private var productionFilter: Bool = false
    
    let siteId: String
    
    var body: some View {
        LoadingView(
            loadingState: $deploysLoadingState,
            failure: { error in
                FailureView(error.localizedDescription, action: listSiteDeploys)
            }
        ) { deploys in
            List {
                ForEach(filterDeploys(deploys), id: \.id, content: DeployItems.init)
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
        .onAppear(perform: listSiteDeploys)
    }
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: siteId)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                deploysLoadingState = .success(value)
            case let .failure(error):
                deploysLoadingState = .failure(error)
            }
        }
    }
    
    func filterDeploys(_ deploys: [Deploy]) -> [Deploy] {
        return deploys
            .filter { deploy -> Bool in
                switch stateFilter {
                case .allState:
                    return true
                case let .filteredByState(state):
                    return state == deploy.state
                }
            }
            .filter { deploy -> Bool in
                return productionFilter ? deploy.context == .production : true
            }
    }
    
    private var filtersApplied: Bool {
        stateFilter != .allState || productionFilter
    }
}
