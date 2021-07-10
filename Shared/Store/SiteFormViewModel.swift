//
//  SiteFormViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteFormViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Submission]> = .loading(.arrayPlaceholder)
    
    func load(_ formId: String) async {
        do {
            let value: [Submission] = try await Loader.shared.fetch(.submissions(formId))
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.arrayPlaceholder, error: error)
            print(error)
        }
    }
}
