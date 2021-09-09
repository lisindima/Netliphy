//
//  PluginStateItems.swift
//  PluginStateItems
//
//  Created by Дмитрий on 07.09.2021.
//

import SwiftUI

struct PluginRunItems: View {
    let plugin: PluginRun
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(plugin.state.color)
                .frame(width: 7)
            VStack(alignment: .leading) {
                Text(plugin.package)
                    .font(.footnote)
                    .fontWeight(.bold)
                if let title = plugin.title {
                    Text(title)
                        .font(.footnote)
                }
                if let summary = plugin.summary {
                    Text(summary)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
        }
    }
}
