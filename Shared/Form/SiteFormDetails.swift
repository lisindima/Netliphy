//
//  SiteFormDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SiteFormDetails: View {
    @StateObject private var viewModel = SiteFormViewModel()
    
    let siteForm: SiteForm
    
    var body: some View {
        LoadingView(viewModel.loadingState) { submissions in
            List {
                ForEach(submissions, id: \.id, content: SubmissionsItems.init)
            }
            .refreshable {
                await viewModel.load(siteForm.id)
            }
        }
        .navigationTitle(siteForm.name)
        .task {
            await viewModel.load(siteForm.id)
        }
    }
}
