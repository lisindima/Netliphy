//
//  LogView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogView: View {
    @State private var logLoadingState: LoadingState<Log> = .loading(.placeholder)
    @State private var showingExporter: Bool = false
    @State private var logForExport: String = ""
    
    let logAccessAttributes: LogAccessAttributes
    
    var body: some View {
        LoadingView(
            loadingState: $logLoadingState,
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
        .navigationTitle("navigation_title_logs")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .success = logLoadingState {
                    Button(action: openFileExporter) {
                        Label("toolbar_button_export_log", systemImage: "doc.badge.plus")
                    }
                }
            }
        }
        .fileExporter(
            isPresented: $showingExporter,
            document: LogFile(logForExport),
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
        .onAppear {
            async {
                await loadLog()
            }
        }
    }
    
    let loader = Loader()
    
    private func loadLog() async {
        do {
            let value: Log = try await loader.fetch(.log(url: logAccessAttributes.url), setToken: false)
            logLoadingState = .success(value)
        } catch {
            logLoadingState = .failure(error)
        }
    }
    
    private func openFileExporter() {
        if case let .success(value) = logLoadingState {
            value.keys.sorted().forEach { log in
                logForExport.append(value[log]!.ts.formatted() + ": " + value[log]!.log.withoutTags)
                logForExport.append("\n")
            }
            showingExporter = true
        }
    }
}
