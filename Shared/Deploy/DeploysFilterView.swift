//
//  DeploysFilterView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.05.2021.
//

import SwiftUI

struct DeploysFilterView: View {
    @Environment(\.presentationMode) @Binding private var presentationMode
    
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
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                Section {
                    Button("clear_filters") {
                        withAnimation {
                            stateFilter = .allState
                            productionFilter = false
                        }
                    }
                    .disabled(!filtersApplied)
                }
            }
            .navigationTitle("navigation_title_filter")
            .toolbar {
                Button("close_button") {
                    presentationMode.dismiss()
                }
            }
        }
    }
    
    private var filtersApplied: Bool {
        stateFilter != .allState || productionFilter
    }
}
