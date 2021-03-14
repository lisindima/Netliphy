//
//  LogView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogView: View {
    @State private var logLoadingState: LoadingState<Log> = .loading
    
    var logAccessAttributes: LogAccessAttributes
    
    private func loadLog() {
        Endpoint.api.fetch(.log(url: logAccessAttributes.url), setToken: false) { (result: Result<Log, ApiError>) in
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
        }
        .navigationTitle("Журнал сборки")
    }
}
