//
//  SiteFormViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteFormViewModel: ObservableObject {
    @Published private(set) var submissionsLoadingState: LoadingState<[Submission]> = .loading(Array(repeating: .placeholder, count: 3))
    
    func load(_ formId: String) async {
        do {
            let value: [Submission] = try await Loader.shared.fetch(.submissions(formId: formId))
            submissionsLoadingState = .success(value)
        } catch {
            submissionsLoadingState = .failure(error)
            print(error)
        }
    }
}

