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
        do {
            async let deploys: [Deploy] = try Loader.shared.fetch(.deploys(siteId, items: 5))
            async let forms: [SiteForm] = try Loader.shared.fetch(.forms(siteId))
            async let functions: FunctionInfo = try Loader.shared.fetch(.functions(siteId))
            let siteStatus: SiteLoader = try await SiteLoader(deploys: deploys, forms: forms, functions: functions)
            siteLoadingState = .success(siteStatus)
        } catch {
            siteLoadingState = .failure(.placeholder, error: error)
            print(error)
        }
    }
}
