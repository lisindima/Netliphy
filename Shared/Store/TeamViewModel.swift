//
//  TeamViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class TeamViewModel: ObservableObject {
    @Published private(set) var bandwidthLoadingState: LoadingState<Bandwidth> = .loading(.placeholder)
    @Published private(set) var statusLoadingState: LoadingState<BuildStatus> = .loading(.placeholder)
    @Published private(set) var membersLoadingState: LoadingState<[Member]> = .loading(Array(repeating: .placeholder, count: 1))
    
    func all(_ slug: String) async {
        await getBandwidth(slug)
        await getStatus(slug)
        await listMembersForAccount(slug)
    }
    
    func getBandwidth(_ slug: String) async {
        do {
            let value: Bandwidth = try await Loader.shared.fetch(.bandwidth(slug))
            bandwidthLoadingState = .success(value)
        } catch {
            bandwidthLoadingState = .failure(error)
            print(error)
        }
    }
    
    func getStatus(_ slug: String) async {
        do {
            let value: BuildStatus = try await Loader.shared.fetch(.status(slug))
            statusLoadingState = .success(value)
        } catch {
            statusLoadingState = .failure(error)
            print(error)
        }
    }
    
    func listMembersForAccount(_ slug: String) async {
        do {
            let value: [Member] = try await Loader.shared.fetch(.members(slug))
            membersLoadingState = .success(value)
        } catch {
            membersLoadingState = .failure(error)
            print(error)
        }
    }
}
