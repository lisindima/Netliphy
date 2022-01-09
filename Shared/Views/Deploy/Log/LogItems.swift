//
//  LogItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct LogItems: View {
    let log: Log
    
    var body: some View {
        HStack {
            Text(log.date, style: .time)
                .fontWeight(.bold)
                .foregroundColor(log.colorMessage?.opacity(0.5) ?? .secondary)
            Divider()
            Text(log.message.withoutTags)
                .foregroundColor(log.colorMessage)
        }
        .font(.footnote.monospaced())
        .lineLimit(1)
    }
}
