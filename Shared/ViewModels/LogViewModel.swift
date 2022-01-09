//
//  LogViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.07.2021.
//

import SwiftUI

@MainActor
class LogViewModel: ObservableObject {
    @Published var logs: [Log] = []
    
    func load(url: String, token: String) async {
        if Task.isCancelled { return }
        do {
            let dictionary: [String: Log] = try await Loader.shared.fetch(for: .log(url: url), token: token)
            if Task.isCancelled { return }
            var value: [Log] = []
            for key in dictionary.keys.sorted() {
                value.append(dictionary[key]!)
            }
            logs = value
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
        }
    }
}
