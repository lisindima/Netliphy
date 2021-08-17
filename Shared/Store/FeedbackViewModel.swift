//
//  FeedbackViewModel.swift
//  FeedbackViewModel
//
//  Created by Дмитрий Лисин on 17.08.2021.
//

import SwiftUI

@MainActor
class FeedbackViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Issue]> = .loading(.arrayPlaceholder)
    
    func load() async {
        if Task.isCancelled { return }
        do {
            let value: [Issue] = try await Loader.shared.fetch(for: .issue, token: "token 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")
            if Task.isCancelled { return }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("listFeedback", error)
        }
    }
}
