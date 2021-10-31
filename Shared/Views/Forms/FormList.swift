//
//  FormList.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

struct FormList: View {
    @StateObject private var viewModel = FormViewModel()
    
    let siteId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { forms in
            List {
                ForEach(forms, content: SiteFormItems.init)
            }
            .refreshable {
                await viewModel.load(siteId)
            }
        }
        .navigationTitle("Forms")
        .task {
            await viewModel.load(siteId)
        }
    }
}
