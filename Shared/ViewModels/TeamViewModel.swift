//
//  TeamViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class TeamViewModel: ObservableObject {    
    @Published private(set) var loadingState: LoadingState<TeamLoader> = .loading(.placeholder)
    
    func load(_ slug: String) async {
        if Task.isCancelled { return }
        do {
            async let bandwidth: Bandwidth = try Loader.shared.fetch(for: .bandwidth(slug))
            async let buildStatus: BuildStatus = try Loader.shared.fetch(for: .status(slug))
            async let members: [Member] = try Loader.shared.fetch(for: .members(slug))
            let teamLoader = try await TeamLoader(bandwidth: bandwidth, buildStatus: buildStatus, members: members)
            if Task.isCancelled { return }
            loadingState = .success(teamLoader)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print(error)
        }
    }
}
