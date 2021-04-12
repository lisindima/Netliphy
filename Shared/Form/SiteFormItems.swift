//
//  SiteFormItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SiteFormItems: View {
    var siteForm: SiteForm
    
    var body: some View {
        NavigationLink(destination: SiteFormDetails(siteForm: siteForm)) {
            VStack(alignment: .leading) {
                Group {
                    Text(siteForm.name)
                        .fontWeight(.bold)
                    Text(siteForm.lastSubmissionAt)
                }
                .font(.footnote)
                .lineLimit(1)
            }
        }
    }
}
