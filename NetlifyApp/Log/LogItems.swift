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
        HStack(alignment: .top) {
            Text(log.ts, style: .time)
            Text(log.log)
        }
        .font(.caption2)
        .multilineTextAlignment(.leading)
        .contextMenu {
            Button(action: {}) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
        }
    }
}
