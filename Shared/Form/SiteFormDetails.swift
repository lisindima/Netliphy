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
    
    var body: some View {
        LoadingView(
            loadingState: $submissionsLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { submissions in
            List {
                ForEach(submissions, id: \.id, content: SubmissionsItems.init)
            }
            .refreshable {
                await listSiteSubmissions()
            }
        }
        .navigationTitle(siteForm.name)
        .task {
            await listSiteSubmissions()
        }
    }
    
    let loader = Loader()
    
    private func listSiteSubmissions() async {
        do {
            let value: [Submission] = try await loader.fetch(.submissions(formId: siteForm.id))
            submissionsLoadingState = .success(value)
        } catch {
            submissionsLoadingState = .failure(error)
            print(error)
        }
    }
}
