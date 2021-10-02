//
//  TipsView.swift
//  TipsView
//
//  Created by Дмитрий Лисин on 21.07.2021.
//

import SwiftUI
import SPIndicator

struct TipsView: View {
    @StateObject private var viewModel = TipsViewModel()
    
    var body: some View {
        List {
            Section {
                if viewModel.tips.isEmpty {
                    Label {
                        Text("Loading")
                    } icon: {
                        ProgressView()
                            .tint(.accentColor)
                    }
                } else {
                    ForEach(viewModel.tips) { tip in
                        Button {
                            Task {
                                await viewModel.purchase(tip)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tip.displayName)
                                        .foregroundColor(.primary)
                                        .fontWeight(.bold)
                                    Text(tip.description)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(tip.displayPrice)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            } footer: {
                Text("The tip jar helps keep Netliphy running, and helps with getting regular (and substantial) updates pushed out to you. If you enjoy using this app and want to support an independent app developer (that's me, Dmitriy), please consider sending a tip.")
            }
            Button("Test") {
                SPIndicator.present(title: "Error", message: "Нет интернета!", preset: .error, haptic: .error, from: .top)
            }
        }
        .navigationTitle("Tip Jar")
        .animation(.default, value: viewModel.tips)
        .task {
            await viewModel.requestProducts()
        }
    }
}
