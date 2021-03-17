//
//  LogItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogItems: View {
    var log: LogValue
    
    private func copyInPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = log.ts.logDate + ": " + log.log.withoutTags
    }
    
    var body: some View {
        HStack {
            Text(log.ts.logDate)
                .fontWeight(.bold)
            Divider()
            Text(log.log.withoutTags)
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
        .contextMenu {
            Button(action: copyInPasteboard) {
                Label("Скопировать", systemImage: "square.and.arrow.up")
            }
        }
    }
}
