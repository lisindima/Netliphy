//
//  PluginItems.swift
//  PluginItems
//
//  Created by Дмитрий on 04.09.2021.
//

import SwiftUI

struct PluginItems: View {
    let plugin: Plugin
    
    var body: some View {
        Link(destination: plugin.repo) {
            VStack(alignment: .leading) {
                Text(plugin.name)
                    .foregroundColor(.primary)
                    .font(.footnote)
                    .fontWeight(.bold)
                Text("by " + plugin.author)
                    .foregroundColor(.primary)
                    .font(.footnote)
                Text(plugin.description)
                    .foregroundColor(.secondary)
                    .font(.caption2)
            }
        }
    }
}
