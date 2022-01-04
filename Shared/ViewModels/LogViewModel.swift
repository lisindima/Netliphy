//
//  LogViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.07.2021.
//

import SwiftUI

@MainActor
class LogViewModel: ObservableObject {
    @Published var string: String = ""
    
    func load(url: String, token: String) async {
        if Task.isCancelled { return }
        do {
            let dictionary: [String: Log] = try await Loader.shared.fetch(for: .log(url: url), token: token)
            if Task.isCancelled { return }
            setValue(dictionary)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
        }
    }
    
    private func setValue(_ dictionary: [String: Log]) {
        var value: [Log] = []
        dictionary.keys.sorted().forEach { key in
            value.append(dictionary[key]!)
        }
        var logsString: String {
            value
                .compactMap { $0.string.withoutTags }
                .joined(separator: "\n")
        }
        string = logsString
    }
}
