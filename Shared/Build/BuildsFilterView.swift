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
                Section(header: Text("Filter builds by:")) {
                    Picker("Site name", selection: $siteNameFilter) {
                        Text("All sites")
                            .tag(SiteNameFilter.allSites)
                        if case let .success(value) = sessionStore.sitesLoadingState {
                            ForEach(value, id: \.id) { site in
                                Text(site.name)
                                    .tag(SiteNameFilter.filteredBySite(site: site.name))
                            }
                        }
                    }
                    Picker("State", selection: $buildStateFilter) {
                        Text("All state")
                            .tag(BuildStateFilter.allState)
                        Label("Error", systemImage: "xmark.circle.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.red)
                            .tag(BuildStateFilter.filteredByState(state: .error))
                        Label("Done", systemImage: "checkmark.circle.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.green)
                            .tag(BuildStateFilter.filteredByState(state: .done))
                        Label("Skipped", systemImage: "star.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.purple)
                            .tag(BuildStateFilter.filteredByState(state: .skipped))
                        Label("Building", systemImage: "gearshape.2.fill")
                            .font(.body.weight(.bold))
                            .foregroundColor(.yellow)
                            .tag(BuildStateFilter.filteredByState(state: .building))
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("Production builds only", systemImage: "bolt.fill")
                    }
                }
                Section {
                    Button(action: {
                        withAnimation {
                            buildStateFilter = .allState
                            siteNameFilter = .allSites
                            productionFilter = false
                        }
                    }) {
                        Text("Clear filters")
                    }
                    .disabled(!filtersApplied)
                }
            }
            .navigationTitle("Filter")
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
