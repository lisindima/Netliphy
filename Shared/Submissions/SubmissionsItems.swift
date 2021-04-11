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
        NavigationLink(destination: Text("dddd")) {
            Label {
                VStack(alignment: .leading) {
                    if let name = submission.name {
                        Text(name)
                            .fontWeight(.bold)
                            .font(.footnote)
                            .lineLimit(1)
                    }
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
