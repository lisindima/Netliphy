//
//  FormViewModel.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[SiteForm]> = .loading(.arrayPlaceholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        do {
            let value: [SiteForm] = try await Loader.shared.fetch(for: .forms(siteId))
            if Task.isCancelled { return }
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("listFunctions", error)
        }
    }
}
