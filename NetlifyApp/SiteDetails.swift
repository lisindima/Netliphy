//
//  SiteDetails.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct SiteDetails: View {
    @State private var deploysLoadingState: LoadingState<[Deploy]> = .loading
    
    var site: Site
    
    private func listSiteDeploys() {
        Endpoint.api.fetch(.deploys(siteId: site.id, items: 5)) { (result: Result<[Deploy], ApiError>) in
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
    
    var header: some View {
        HStack {
            Text("Сборки")
            Spacer()
            NavigationLink(destination: Text("хи-хи")) {
                Text("Еще")
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: header) {
                LoadingView(
                    loadingState: $deploysLoadingState,
                    load: listSiteDeploys
                ) { deploys in
                    List {
                        ForEach(deploys, id: \.id) { deploy in
                            DeployItems(deploy: deploy)
                        }
                    }
                }
            }
        }
        .onAppear(perform: listSiteDeploys)
        .navigationTitle(site.customDomain)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Link(destination: site.url) {
                    Label("Открыть сайт", systemImage: "safari")
                }
            }
        }
    }
}
