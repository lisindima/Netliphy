//
//  SummaryItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import SwiftUI

struct SummaryItems: View {
    let message: Message
    
    var markdown: AttributedString? {
        try? AttributedString(markdown: message.description)
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 5) {
                Text(message.title)
                    .fontWeight(.bold)
                if let markdown = markdown {
                    Text(markdown)
                        .font(.footnote)
                }
                if let details = message.details, !details.isEmpty {
                    Text(details)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
        } icon: {
            message.type
        }
    }
}
