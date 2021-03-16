//
//  SummaryItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import SwiftUI

struct SummaryItems: View {
    var message: Deploy.Message
    
    var body: some View {
        Label {
            VStack {
                Text(message.title)
                if let details = message.details {
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
