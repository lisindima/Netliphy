//
//  SubmissionsItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.04.2021.
//

import SwiftUI

struct SubmissionsItems: View {
    let submission: Submission
    
    var body: some View {
        NavigationLink {
            SubmissionsDetails(submission: submission)
        } label: {
            VStack(alignment: .leading) {
                Group {
                    Text(submission.summary ?? submission.id)
                        .fontWeight(.bold)
                    if let name = submission.name {
                        Text(name)
                    }
                }
                .font(.footnote)
                .lineLimit(1)
                HStack {
                    Text(submission.createdAt, style: .relative) + Text(" ago")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
    }
}
