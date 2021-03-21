//
//  PluginsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.03.2021.
//

import SwiftUI

struct PluginsView: View {
    var plugins: [Plugin]
    
    var body: some View {
        List {
            ForEach(plugins, id: \.self) { plugin in
                Text(plugin.package)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("navigation_title_plugins")
    }
}
