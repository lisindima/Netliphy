//
//  BuildsFilterView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildsFilterView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @Environment(\.presentationMode) @Binding private var presentationMode
    
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
                        if case let .success(value) = sessionStore.sitesLoadingState {
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
                            state.tag(BuildStateFilter.filteredByState(state: state))
                        }
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("production_only", systemImage: "bolt.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                Section {
                    Button("clear_filters") {
                        withAnimation {
                            buildStateFilter = .allState
                            siteNameFilter = .allSites
                            productionFilter = false
                        }
                    }
                    .disabled(!filtersApplied)
                }
            }
            .navigationTitle("navigation_title_filter")
            .navigationBarItems(trailing: navigationItems)
        }
    }
    
    private var navigationItems: some View {
        Button(action: { presentationMode.dismiss() }) {
            ExitButtonView()
        }
        .frame(width: 30, height: 30)
    }
    
    private var filtersApplied: Bool {
        buildStateFilter != .allState || siteNameFilter != .allSites || productionFilter
    }
}
