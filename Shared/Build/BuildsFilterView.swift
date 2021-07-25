//
//  BuildsFilterView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildsFilterView: View {
    @EnvironmentObject private var viewModel: SitesViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("accounts", store: store) private var accounts: Accounts = []
    @AppStorage("selectedSlug", store: store) private var selectedSlug: String = ""
    
    @Binding var buildStateFilter: BuildStateFilter
    @Binding var siteNameFilter: SiteNameFilter
    @Binding var productionFilter: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Site name", selection: $siteNameFilter) {
                        Text("All sites")
                            .fontWeight(.bold)
                            .tag(SiteNameFilter.allSites)
                        if case let .success(value) = viewModel.loadingState {
                            ForEach(value, id: \.id) { site in
                                Text(site.name)
                                    .fontWeight(.bold)
                                    .tag(SiteNameFilter.filteredBySite(site: site.name))
                            }
                        }
                    }
                    Picker("State", selection: $buildStateFilter) {
                        Text("All states")
                            .fontWeight(.bold)
                            .tag(BuildStateFilter.allState)
                        ForEach(BuildState.allCases) { state in
                            state
                                .tag(BuildStateFilter.filteredByState(state: state))
                        }
                    }
                    if let teams = accounts.first?.teams {
                        Picker("Slug", selection: $selectedSlug) {
                            ForEach(teams) { team in
                                Text(team.slug)
                            }
                        }
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("Production only", systemImage: "bolt.fill")
                    }
                    .tint(.accentColor)
                } header: {
                    Text("Filter builds by:")
                }
                Section {
                    Button("Clear filters", action: clearFilter)
                        .disabled(!filtersApplied)
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                Button("Close", action: dismiss.callAsFunction)
            }
        }
    }
    
    private var filtersApplied: Bool {
        buildStateFilter != .allState || siteNameFilter != .allSites || productionFilter
    }
    
    private func clearFilter() {
        withAnimation {
            buildStateFilter = .allState
            siteNameFilter = .allSites
            productionFilter = false
        }
    }
}
