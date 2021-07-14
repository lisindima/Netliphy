//
//  SiteFormItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SiteFormItems: View {
    let siteForm: SiteForm
    
    var body: some View {
        NavigationLink {
            SiteFormDetails(siteForm: siteForm)
        } label: {
            VStack(alignment: .leading) {
                Group {
                    Text(siteForm.name)
                        .fontWeight(.bold)
                    Text("Submission count: \(siteForm.submissionCount)")
                }
                .font(.footnote)
                .lineLimit(1)
                siteForm.lastSubmission
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
