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
    
    @Binding var buildStateFilter: BuildStateFilter
    @Binding var siteNameFilter: SiteNameFilter
    @Binding var productionFilter: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("section_header_filter_builds")) {
                    Picker("picker_title_site_name", selection: $siteNameFilter) {
                        Text("all_sites")
                            .fontWeight(.bold)
                            .tag(SiteNameFilter.allSites)
                        if case let .success(value) = viewModel.sitesLoadingState {
                            ForEach(value, id: \.id) { site in
                                Text(site.name)
                                    .fontWeight(.bold)
                                    .tag(SiteNameFilter.filteredBySite(site: site.name))
                            }
                        }
                    }
                    Picker("picker_title_state", selection: $buildStateFilter) {
                        Text("all_states")
                            .fontWeight(.bold)
                            .tag(BuildStateFilter.allState)
                        ForEach(BuildState.allCases) { state in
                            state
                                .tag(BuildStateFilter.filteredByState(state: state))
                        }
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("production_only", systemImage: "bolt.fill")
                    }
                    .tint(.accentColor)
                }
                Section {
                    Button("clear_filters", action: clearFilter)
                        .disabled(!filtersApplied)
                }
            }
            .navigationTitle("navigation_title_filter")
            .toolbar {
                Button("close_button") {
                    dismiss()
                }
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
