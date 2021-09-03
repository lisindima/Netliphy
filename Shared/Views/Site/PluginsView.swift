//
//  PluginsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.03.2021.
//

import SwiftUI

struct PluginsView: View {
    let plugins: [Plugin]
    
    var body: some View {
        List {
            Section {
                ForEach(plugins, id: \.id) { plugin in
                    Text(plugin.package)
                }
            }
        }
        .navigationTitle("Plugins")
    }
}
