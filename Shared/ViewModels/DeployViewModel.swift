//
//  DeployViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class DeployViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<DeployLoader> = .loading(.placeholder)
    
    func load(_ deployId: String) async {
        if Task.isCancelled { return }
        do {
            async let deploy: Deploy = try await Loader.shared.fetch(for: .deploy(deployId))
            async let pluginState: [PluginState] = try await Loader.shared.fetch(for: .pluginRuns(deployId))
            async let eventDeploy: [EventDeploy]? = try? await Loader.shared.fetch(for: .eventDeploy(deployId))
            let deployLoader = try await DeployLoader(deploy: deploy, pluginState: pluginState, eventDeploy: eventDeploy)
            if Task.isCancelled { return }
            loadingState = .success(deployLoader)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print(error)
        }
    }
}
