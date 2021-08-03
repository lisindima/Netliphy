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
                        if let value = usage.capabilities.values.first, let key = usage.capabilities.keys.first {
                            ProgressView(
                                value: value.used,
                                total: value.included
                            ) {
                                Text(key)
                                    .fontWeight(.bold)
                                Text("Updated \(usage.lastUpdatedAt.formatted())")
                                    .font(.caption2)
                            } currentValueLabel: {
                                HStack {
                                    Text("\(Int(value.used))")
                                    Spacer()
                                    Text("\(Int(value.included))")
                                }
                            }
                        }
                    } header: {
                        Text("ddsdsd")
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
}
