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
    @State private var stateFilter: StateFilter = .allState
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
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { showFilter = true }) {
                        Image(systemName: filtersApplied
                                ? "line.horizontal.3.decrease.circle.fill"
                                : "line.horizontal.3.decrease.circle"
                        )
                    }
                    .unredacted()
                }
                ToolbarItem(placement: .status) {
                    VStack(alignment: .center) {
                        if filtersApplied {
                            Text("\(filterDeploys(deploys).count) of \(deploys.count) deploys shown")
                            Button(action: { showFilter = true }) {
                                Text("Filters applied")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        } else if case .loading = deploysLoadingState {
                            Text("0 deploys shown")
                        } else {
                            Text("\(deploys.count) deploys shown")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .unredacted()
                }
            }
        }
        .navigationTitle("navigation_title_deploys")
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
                switch self.stateFilter {
                case .allState:
                    return true
                case .filteredByState(let state):
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
