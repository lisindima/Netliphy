//
//  EnvView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.04.2021.
//

import SwiftUI

struct EnvView: View {
    @EnvironmentObject private var sitesViewModel: SitesViewModel
    
    @StateObject private var viewModel = EnvViewModel()
    
    private let env: [String: String]?
    private let siteId: String
    
    init(_ site: Site) {
        siteId = site.id
        env = site.buildSettings.env
    }
    
    var body: some View {
        List {
            Section {
                ForEach($viewModel.arrayEnv) { $env in
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
                                viewModel.deleteEnv(env: env)
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
                        viewModel.arrayEnv.append(Env(key: "", value: ""))
                    }
                } label: {
                    Label("New varible", systemImage: "plus.circle.fill")
                        .font(.body.weight(.bold))
                }
            }
            if env != viewModel.convertEnvToDictionary() {
                Section {
                    Button {
                        Task {
                            await viewModel.updateEnv(siteId)
                            await sitesViewModel.load()
                        }
                    } label: {
                        Label("Save", systemImage: "square.and.arrow.down.fill")
                            .font(.body.weight(.bold))
                    }
                }
            }
        }
        .navigationTitle("Environment Variables")
        .toolbar {
            Link(destination: URL(string: "https://docs.netlify.com/configure-builds/environment-variables")!) {
                Label("Help", systemImage: "questionmark.circle")
            }
        }
        .onAppear {
            viewModel.convertEnvToArray(env)
        }
    }
}
