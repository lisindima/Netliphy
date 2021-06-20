//
//  SiteViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class SiteViewModel: ObservableObject {
    @Published private(set) var deploysLoadingState: LoadingState<[Deploy]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published private(set) var formsLoadingState: LoadingState<[SiteForm]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published private(set) var functionsLoadingState: LoadingState<FunctionInfo> = .loading(.placeholder)
    
    func load(_ site: String) async {
        await listSiteDeploys(site)
        await listSiteForms(site)
        await listSiteFunctions(site)
    }
    
    func listSiteDeploys(_ siteId: String) async {
        do {
            let value: [Deploy] = try await Loader.shared.fetch(.deploys(siteId, items: 5))
            deploysLoadingState = .success(value)
        } catch {
            deploysLoadingState = .failure(error)
            print(error)
        }
    }
    
    func listSiteForms(_ siteId: String) async {
        do {
            let value: [SiteForm] = try await Loader.shared.fetch(.forms(siteId))
            formsLoadingState = .success(value)
        } catch {
            formsLoadingState = .failure(error)
            print(error)
        }
    }
    
    func listSiteFunctions(_ siteId: String) async {
        do {
            let value: FunctionInfo = try await Loader.shared.fetch(.functions(siteId))
            functionsLoadingState = .success(value)
        } catch {
            functionsLoadingState = .failure(error)
            print(error)
        }
    }
}
