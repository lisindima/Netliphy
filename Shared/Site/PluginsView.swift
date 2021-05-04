//
//  PluginsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.03.2021.
//

import SwiftUI

struct PluginsView: View {
    let plugins: [Plugin]
    
    var footer: some View {
        Link("footer_list_plugins", destination: URL(string: "https://docs.netlify.com/configure-builds/build-plugins/")!)
    }
    
    var body: some View {
        List {
            Section(footer: footer) {
                ForEach(plugins, id: \.package) { plugin in
                    Text(plugin.package)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("navigation_title_plugins")
    }
}
