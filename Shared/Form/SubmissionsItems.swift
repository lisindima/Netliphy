//
//  SubmissionsItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.04.2021.
//

import SwiftUI

struct SubmissionsItems: View {
    var submission: Submission
    
    var body: some View {
        NavigationLink(destination: SubmissionsDetails(submission: submission)) {
            Label {
                VStack(alignment: .leading) {
                    Group {
                        if let name = submission.name {
                            Text(name)
                                .fontWeight(.bold)
                        }
                        Text(submission.formName)
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    HStack {
                        Text(submission.createdAt, style: .relative) + Text("site_items_ago")
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            } icon: {
                Image(systemName: "envelope.fill")
            }
        }
    }
}
