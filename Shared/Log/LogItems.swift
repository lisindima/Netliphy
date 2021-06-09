//
//  LogItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogItems: View {
    let log: LogValue
    
    var body: some View {
        HStack {
            Text(log.ts.formatted())
                .fontWeight(.bold)
            Divider()
            Text(log.log.withoutTags)
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
        .contextMenu {
            Button(action: copyInPasteboard) {
                Label("menu_copy_log", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    private func copyInPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = log.ts.formatted() + ": " + log.log.withoutTags
    }
}
