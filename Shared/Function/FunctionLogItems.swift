//
//  FunctionLogItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.06.2021.
//

import SwiftUI

struct FunctionLogItems: View {
    let log: FunctionLog
    
    var body: some View {
        if log.type != "start" {
            HStack {
                Text(log.date.formatted())
                    .fontWeight(.bold)
                if let requestId = log.requestId {
                    Text(requestId)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
                if let level = log.level, log.type != "report" {
                    Text(level)
                }
                if let message = log.message {
                    Text(message.withoutNewLines)
                        .foregroundColor(log.type != "report" ? .primary : .accentColor)
                        .fontWeight(log.type != "report" ? .regular : .bold)
                }
            }
            .font(.system(.caption2, design: .monospaced))
        }
    }
}
