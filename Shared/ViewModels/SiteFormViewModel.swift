//
//  SiteFormViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteFormViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Submission]> = .placeholder(.arrayPlaceholder)
    
    func load(_ formId: String, submissionsType: SubmissionsType) async {
        if Task.isCancelled { return }
        do {
            let value: [Submission] = try await Loader.shared.fetch(for: submissionsType == .verified ? .submissions(formId) : .spamSubmissions(formId))
            if Task.isCancelled { return }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print(error)
        }
    }
}
