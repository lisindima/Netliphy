//
//  SiteFormDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SiteFormDetails: View {
    @StateObject private var viewModel = SiteFormViewModel()
    
    @State private var submissionsType: SubmissionsType = .verified
    
    let siteForm: SiteForm
    
    var body: some View {
        LoadingView(viewModel.loadingState) { submissions in
            List {
                ForEach(submissions, content: SubmissionsItems.init)
            }
            .refreshable {
                await viewModel.load(siteForm.id, submissionsType: submissionsType)
            }
        }
        .navigationTitle(submissionsType.title)
        .toolbar {
            Picker(selection: $submissionsType) {
                ForEach(SubmissionsType.allCases) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            } label: {
                Label("Filter", systemImage:
                        submissionsType == .verified
                      ? "line.horizontal.3.decrease.circle"
                      : "line.horizontal.3.decrease.circle.fill"
                )
            }
        }
        .task(id: submissionsType) {
            await viewModel.load(siteForm.id, submissionsType: submissionsType)
        }
    }
}

enum SubmissionsType: String, CaseIterable, Identifiable {
    case verified = "Verified"
    case spam = "Spam"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .verified:
            return "Verified submissions"
        case .spam:
            return "Spam submissions"
        }
    }
}
