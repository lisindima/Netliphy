//
//  LogView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogView: View {
    @State private var logLoadingState: LoadingState<Log> = .loading
    @State private var showingExporter: Bool = false
    @State private var logForExport: String = ""
    
    var deploy: Deploy
    
    private func loadLog() {
        print("loadLog")
        
        Endpoint.api.fetch(.log(url: deploy.logAccessAttributes.url), setToken: false) { (result: Result<Log, ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    logLoadingState = .empty
                } else {
                    logLoadingState = .success(value)
                }
            case let .failure(error):
                logLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    private func openFileExporter() {
        switch logLoadingState {
        case .loading, .empty, .failure:
            return
        case let .success(value):
            value.keys.sorted().forEach { log in
                logForExport.append(value[log]!.ts.logDate + ": " + value[log]!.log.withoutTags)
                logForExport.append("\n")
            }
            showingExporter = true
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $logLoadingState,
            load: loadLog
        ) { logs in
            ScrollView([.horizontal, .vertical]) {
                LazyVStack(alignment: .leading) {
                    ForEach(logs.keys.sorted(), id: \.self) { key in
                        LogItems(log: logs[key]!)
                    }
                }
                .frame(width: 3000)
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: openFileExporter) {
                        Label("Поделиться логами", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .fileExporter(
                isPresented: $showingExporter,
                document: LogFile(logForExport),
                contentType: .plainText,
                defaultFilename: deploy.buildId
            ) { result in
                switch result {
                case let .success(url):
                    print("Saved to \(url)")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
        .navigationTitle("Журнал сборки")
    }
}
