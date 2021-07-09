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
        LoadingView(
            loadingState: viewModel.loadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { logs in
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment: .leading) {
                    ForEach(logs.keys.sorted(), id: \.self) { key in
                        LogItems(log: logs[key]!)
                    }
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
            await viewModel.load(logAccessAttributes.url)
        }
    }
}
