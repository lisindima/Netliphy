//
//  DeploysFilterView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.05.2021.
//

import SwiftUI

struct DeploysFilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var stateFilter: DeployStateFilter
    @Binding var productionFilter: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("section_header_filter_deployments")) {
                    Picker("picker_title_state", selection: $stateFilter) {
                        Text("all_states")
                            .fontWeight(.bold)
                            .tag(DeployStateFilter.allState)
                        ForEach(DeployState.allCases) { state in
                            state.tag(DeployStateFilter.filteredByState(state: state))
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
        stateFilter != .allState || productionFilter
    }
    
    private func clearFilter() {
        withAnimation {
            stateFilter = .allState
            productionFilter = false
        }
    }
}
