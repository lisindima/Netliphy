//
//  EnvView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.04.2021.
//

import SwiftUI

struct EnvView: View {
    @EnvironmentObject private var sitesViewModel: SitesViewModel
    
    @State private var arrayEnv: [Env] = []
    
    let env: [String: String]?
    let siteId: String
    
    var body: some View {
        List {
            Section {
                ForEach($arrayEnv) { $env in
                    HStack {
                        TextField("VARIABLE_NAME", text: $env.key)
                            .font(.footnote.weight(.bold))
                        Divider()
                        TextField("somevalue", text: $env.value)
                            .font(.footnote.monospaced())
                    }
                    .disableAutocorrection(true)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            withAnimation {
                                deleteEnv(env: env)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            Section {
                Button {
                    withAnimation {
                        arrayEnv.append(Env(key: "", value: ""))
                    }
                } label: {
                    Label("New varible", systemImage: "plus.circle.fill")
                        .font(.body.weight(.bold))
                }
            }
        }
        .navigationTitle("Environment Variables")
        .onAppear(perform: convertEnvToArray)
        .onDisappear {
            Task {
                await updateEnv(siteId)
            }
        }
    }
    
    private func convertEnvToArray() {
        guard let env = env else { return }
        env.sorted(by: <).forEach { key, value in
            arrayEnv.append(Env(key: key, value: value))
        }
    }
    
    private func convertEnvToDictionary() -> [String: String] {
        var dictionary: [String: String] = [:]
        arrayEnv.forEach { env in
            dictionary.updateValue(env.value, forKey: env.key)
        }
        return dictionary
    }
    
    private func deleteEnv(env: Env) {
        guard let index = arrayEnv.firstIndex(where: { $0.id == env.id }) else { return }
        arrayEnv.remove(at: index)
    }
    
    @MainActor
    private func updateEnv(_ siteId: String) async {
        let parameters = EnvHelper(buildSettings: .init(env: convertEnvToDictionary()))
        if Task.isCancelled { return }
        do {
            let _: Site = try await Loader.shared.upload(for: .site(siteId), parameters: parameters, httpMethod: .put)
            if Task.isCancelled { return }
            await sitesViewModel.load()
        } catch {
            if Task.isCancelled { return }
            print("updateEnv", error)
        }
    }
}

struct Env: Codable, Identifiable {
    var key: String
    var value: String
    
    var id = UUID()
}

struct EnvHelper: Codable {
    let buildSettings: BuildSettings
    
    struct BuildSettings: Codable {
        let env: [String: String]
    }
}
