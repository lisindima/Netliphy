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
                Section {
                    Picker("State", selection: $stateFilter) {
                        Text("All states")
                            .fontWeight(.bold)
                            .tag(DeployStateFilter.allState)
                        ForEach(DeployState.allCases) { state in
                            state.tag(DeployStateFilter.filteredByState(state: state))
                        }
                    }
                    Toggle(isOn: $productionFilter) {
                        Label("Production only", systemImage: "bolt.fill")
                    }
                    .tint(.accentColor)
                }
                Section {
                    Button("Clear filters", action: clearFilter)
                        .disabled(!filtersApplied)
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title2)
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
