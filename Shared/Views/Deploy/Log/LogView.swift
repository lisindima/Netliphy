//
//  LogView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogView: View {
    @StateObject private var viewModel = LogViewModel()
    
    let logAccessAttributes: LogAccessAttributes
    
    var body: some View {
        VStack {
            if viewModel.string.isEmpty {
                ProgressView()
            } else {
                ScrollView([.horizontal, .vertical]) {
                    Text(viewModel.string)
                        .font(.system(.caption2, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                }
            }
        }
        .navigationTitle("Deploy log")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load(url: logAccessAttributes.url, token: logAccessAttributes.token)
        }
    }
}
