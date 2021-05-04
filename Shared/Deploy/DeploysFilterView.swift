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
                        DeployState.error
                            .tag(DeployStateFilter.filteredByState(state: .error))
                        DeployState.ready
                            .tag(DeployStateFilter.filteredByState(state: .ready))
                        DeployState.new
                            .tag(DeployStateFilter.filteredByState(state: .new))
                        DeployState.building
                            .tag(DeployStateFilter.filteredByState(state: .building))
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("production_deployments_only", systemImage: "bolt.fill")
                    }
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
        stateFilter != .allState || productionFilter
    }
}
