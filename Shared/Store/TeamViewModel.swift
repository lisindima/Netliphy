//
//  TeamViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class TeamViewModel: ObservableObject {    
    @Published private(set) var teamStatusLoadingState: LoadingState<TeamStatus> = .loading(.placeholder)
    
    func load(_ slug: String) async {
        do {
            async let bandwidth: Bandwidth = try Loader.shared.fetch(.bandwidth(slug))
            async let buildStatus: BuildStatus = try Loader.shared.fetch(.status(slug))
            async let members: [Member] = try Loader.shared.fetch(.members(slug))
            let teamStatus = try await TeamStatus(bandwidth: bandwidth, buildStatus: buildStatus, members: members)
            teamStatusLoadingState = .success(teamStatus)
        } catch {
            teamStatusLoadingState = .failure(.placeholder, error: error)
            print(error)
        }
    }
}
