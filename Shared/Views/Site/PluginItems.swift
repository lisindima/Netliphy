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
                    .font(.footnote)
                    .fontWeight(.bold)
                Text("by " + plugin.author)
                    .font(.footnote)
                Text(plugin.description)
                    .foregroundColor(.secondary)
                    .font(.caption2)
            }
        }
    }
}
