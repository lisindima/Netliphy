//
//  LogItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogItems: View {
    var log: LogValue
    
    var body: some View {
        HStack {
            Text(log.ts, style: .date)
                .fontWeight(.bold)
            Text(log.ts, style: .time)
                .fontWeight(.bold)
            Divider()
            Text(log.log)
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
        .contextMenu {
            Button(action: {}) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
        }
    }
}
