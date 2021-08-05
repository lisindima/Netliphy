//
//  UsageView.swift
//  UsageView
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import SwiftUI

struct UsageView: View {
    @StateObject private var viewModel = UsageViewModel()
    
    let siteId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { usages in
            List {
                ForEach(usages) { usage in
                    Section {
                        ForEach(usage.capabilities.keys.sorted(), id: \.self) { key in
                            if let value = usage.capabilities[key] {
                                ProgressView(
                                    value: value.used,
                                    total: value.included
                                ) {
                                    Text(key.localizedUsageKey)
                                        .fontWeight(.bold)
                                    Text("Updated \(usage.lastUpdatedAt.formatted())")
                                        .font(.caption2)
                                } currentValueLabel: {
                                    currentValueLabel(value)
                                }
                            }
                        }
                    } header: {
                        Text(usage.type)
                    } footer: {
                        Text(usage.description)
                    }
                }
            }
        }
        .navigationTitle("Usage")
        .task {
            await viewModel.load(siteId)
        }
    }
    
    private func currentValueLabel(_ statsData: StatsData) -> some View {
        HStack {
            Text(statsData.used.getUnit(unit: statsData.unit))
            Spacer()
            Text(statsData.included.getUnit(unit: statsData.unit))
        }
    }
}
