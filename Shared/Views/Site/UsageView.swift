//
//  UsageView.swift
//  UsageView
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import SwiftUI

struct UsageView: View {
    @StateObject private var viewModel = UsageViewModel()
    
    private let siteId: String
    
    init(_ site: Site) {
        siteId = site.id
    }
    
    var body: some View {
        LoadingView(viewModel.loadingState) { usages in
            List {
                ForEach(usages) { usage in
                    Section {
                        ForEach(usage.stats) { item in
                            ProgressView(
                                value: item.used,
                                total: item.included
                            ) {
                                Text(item.title)
                                    .fontWeight(.bold)
                                Text("Updated \(usage.lastUpdatedAt.formatted())")
                                    .font(.caption2)
                            } currentValueLabel: {
                                currentValueLabel(item)
                            }
                        }
                    } header: {
                        Text(usage.type)
                    } footer: {
                        Text(usage.description)
                    }
                }
            }
            .refreshable {
                await viewModel.load(siteId)
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
