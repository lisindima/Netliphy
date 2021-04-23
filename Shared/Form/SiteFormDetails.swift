//
//  SiteFormDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SiteFormDetails: View {
    @State private var submissionsLoadingState: LoadingState<[Submission]> = .loading(Array(repeating: .placeholder, count: 3))
    
    let siteForm: SiteForm
    
    private func listSiteSubmissions() {
        Endpoint.api.fetch(.submissions(formId: siteForm.id)) { (result: Result<[Submission], ApiError>) in
            switch result {
            case let .success(value):
                submissionsLoadingState = .success(value)
            case let .failure(error):
                submissionsLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    var body: some View {
        LoadingView(
            loadingState: $submissionsLoadingState,
            failure: { error in
                FailureView(error.localizedDescription, action: listSiteSubmissions)
            }
        ) { submissions in
            List {
                ForEach(submissions, id: \.id, content: SubmissionsItems.init)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .onAppear(perform: listSiteSubmissions)
        .navigationTitle(siteForm.name)
    }
}
