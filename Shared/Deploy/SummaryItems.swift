//
//  SummaryItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import MarkdownUI
import SwiftUI

struct SummaryItems: View {
    var message: Deploy.Message
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 5) {
                Text(message.title)
                    .fontWeight(.bold)
                Markdown(Document(message.description))
                    .markdownStyle(DefaultMarkdownStyle(font: .system(.footnote)))
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
