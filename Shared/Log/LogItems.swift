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
            Text(log.date.formatted())
                .fontWeight(.bold)
            Divider()
            Text(log.message.withoutTags)
        }
        .font(.system(.caption2, design: .monospaced))
        .lineLimit(1)
    }
}
