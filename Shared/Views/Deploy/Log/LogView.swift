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
            if !viewModel.logs.isEmpty {
                ScrollView([.vertical, .horizontal]) {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.logs, content: LogItems.init)
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Deploy log")
        .task {
            await viewModel.load(url: logAccessAttributes.url, token: logAccessAttributes.token)
        }
    }
}
