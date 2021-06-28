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
        NavigationLink(destination: SiteFormDetails(siteForm: siteForm)) {
            VStack(alignment: .leading) {
                Group {
                    Text(siteForm.name)
                        .fontWeight(.bold)
                    Text("Submission count: \(siteForm.submissionCount)")
                }
                .font(.footnote)
                .lineLimit(1)
                HStack {
                    Text("Last submission ") + Text(siteForm.lastSubmissionAt, style: .relative) + Text(" ago")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
    }
}
