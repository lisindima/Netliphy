//
//  DeploysList.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 10.03.2021.
//

import SwiftUI

struct DeploysList: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading
    
    var site: Site
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: site.id)) { (result: Result<[Deploy], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    deploysLoadingState = .empty
                } else {
                    deploysLoadingState = .success(value)
                }
            case let .failure(error):
                deploysLoadingState = .failure(error)
            }
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $deploysLoadingState,
            load: listSiteDeploys
        ) { deploys in
            List {
                ForEach(deploys, id: \.id) { deploy in
                    DeployItems(deploy: deploy)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Cборки")
    }
}
