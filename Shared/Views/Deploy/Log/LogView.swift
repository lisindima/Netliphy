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
        LoadingView(viewModel.loadingState) { logs in
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    ForEach(logs, content: LogItems.init)
                }
                .padding()
            }
        }
        .navigationTitle("Deploy log")
        .toolbar {
            if case .success = viewModel.loadingState {
                Button {
                    viewModel.openFileExporter()
                } label: {
                    Label("Export log", systemImage: "doc.badge.plus")
                }
            }
        }
        .fileExporter(
            isPresented: $viewModel.showingExporter,
            document: viewModel.logFile,
            contentType: .plainText,
            defaultFilename: "build_log"
        ) { result in
            switch result {
            case let .success(url):
                print("Saved to \(url)")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        .task {
            await viewModel.load(url: logAccessAttributes.url, token: logAccessAttributes.token)
        }
    }
}
