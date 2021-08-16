//
//  SiteViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteViewModel: ObservableObject {
    @Published private(set) var siteLoadingState: LoadingState<SiteLoader> = .loading(.placeholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        do {
            async let deploys: [Deploy] = try Loader.shared.fetch(for: .deploys(siteId, items: 5))
            async let forms: [SiteForm] = try Loader.shared.fetch(for: .forms(siteId))
            async let functions: FunctionInfo = try Loader.shared.fetch(for: .functions(siteId))
            let siteStatus: SiteLoader = try await SiteLoader(deploys: deploys, forms: forms, functions: functions)
            if Task.isCancelled { return }
            siteLoadingState = .success(siteStatus)
        } catch {
            if Task.isCancelled { return }
            siteLoadingState = .failure(error)
            print(error)
        }
    }
}
