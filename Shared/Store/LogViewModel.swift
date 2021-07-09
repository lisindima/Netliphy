//
//  LogViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.07.2021.
//

import SwiftUI

@MainActor
class LogViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<Log> = .loading(.placeholder)
    @Published private(set) var logFile = LogFile("")
    @Published var showingExporter: Bool = false
    
    func load(_ url: String) async {
        do {
            let value: Log = try await Loader.shared.fetch(.log(url: url), setToken: false)
            loadingState = .success(value)
        } catch {
            loadingState = .failure(error)
        }
    }
    
    func openFileExporter() {
        if case let .success(value) = loadingState {
            var logsString = ""
            value.keys.sorted().forEach { log in
                logsString.append(value[log]!.date.formatted() + ": " + value[log]!.message.withoutTags)
                logsString.append("\n")
            }
            logFile = LogFile(logsString)
            showingExporter = true
        }
    }
}
