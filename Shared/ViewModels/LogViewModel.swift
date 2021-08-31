//
//  LogViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.07.2021.
//

import SwiftUI

@MainActor
class LogViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Log]> = .loading(.arrayPlaceholder)
    @Published private(set) var logFile = LogFile("")
    @Published var showingExporter: Bool = false
    
    func load(url: String, token: String) async {
        if Task.isCancelled { return }
        do {
            let dictionary: [String: Log] = try await Loader.shared.fetch(for: .log(url: url), token: token)
            if Task.isCancelled { return }
            var value: [Log] = []
            for key in dictionary.keys.sorted() {
                value.append(dictionary[key]!)
            }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
        }
    }
    
    func openFileExporter() {
        if case let .success(value) = loadingState {
            var logsString = ""
            for log in value {
                logsString.append(log.date.formatted() + ": " + log.message.withoutTags)
                logsString.append("\n")
            }
            logFile = LogFile(logsString)
            showingExporter = true
        }
    }
}
