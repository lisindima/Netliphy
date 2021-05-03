//
//  BuildsFilterView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildsFilterView: View {
    @Environment(\.presentationMode) @Binding private var presentationMode
    
    @Binding var stateFilter: BuildStateFilter
    @Binding var productionFilter: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filter deployments by:")) {
                    Picker("State", selection: $stateFilter) {
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
                        Label("Production deploys only", systemImage: "bolt.fill")
                    }
                }
                Section {
                    Button(action: {
                        withAnimation {
                            stateFilter = .allState
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
        stateFilter != .allState || productionFilter
    }
}
