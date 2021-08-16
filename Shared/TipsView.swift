//
//  TipsView.swift
//  TipsView
//
//  Created by Дмитрий Лисин on 21.07.2021.
//

import StoreKit
import SwiftUI

struct TipsView: View {
    @StateObject private var viewModel = TipsStore()
    
    var body: some View {
        VStack {
            if viewModel.tips.isEmpty {
                ProgressView()
            } else {
                List {
                    Section {
                        ForEach(viewModel.tips) { tip in
                            Button {
                                Task {
                                    await purchase(tip)
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(tip.displayName)
                                            .foregroundColor(.primary)
                                            .fontWeight(.bold)
                                        Text(tip.description)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(tip.displayPrice)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    } footer: {
                        Text("The tip jar helps keep Netliphy running, and helps with getting regular (and substantial) updates pushed out to you. If you enjoy using this app and want to support an independent app developer (that's me, Dmitriy), please consider sending a tip.")
                    }
                }
            }
        }
        .navigationTitle("Tip Jar")
        .task {
            await viewModel.requestProducts()
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async {
        do {
            if let successPurchase = try await viewModel.purchase(product) {
                print(successPurchase)
            }
        } catch {
            print("Failed fuel purchase: \(error)")
        }
    }
}
