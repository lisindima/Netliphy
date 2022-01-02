//
//  EnvViewModel.swift
//  Netliphy
//
//  Created by Дмитрий on 02.01.2022.
//

import SwiftUI

@MainActor
class EnvViewModel: ObservableObject {
    @Published var arrayEnv: [Env] = []
    
    func convertEnvToArray(_ env: [String: String]?) {
        guard let env = env else { return }
        env.sorted(by: <).forEach { key, value in
            arrayEnv.append(Env(key: key, value: value))
        }
    }
    
    func convertEnvToDictionary() -> [String: String] {
        var dictionary: [String: String] = [:]
        arrayEnv.forEach { env in
            dictionary.updateValue(env.value, forKey: env.key)
        }
        return dictionary
    }
    
    func deleteEnv(env: Env) {
        guard let index = arrayEnv.firstIndex(where: { $0.id == env.id }) else { return }
        arrayEnv.remove(at: index)
    }
    
    func updateEnv(_ siteId: String) async {
        let parameters = EnvHelper(buildSettings: .init(env: convertEnvToDictionary()))
        if Task.isCancelled { return }
        do {
            let _: Site = try await Loader.shared.upload(for: .site(siteId), parameters: parameters, httpMethod: .put)
            if Task.isCancelled { return }
        } catch {
            if Task.isCancelled { return }
            print("updateEnv", error)
        }
    }
}
