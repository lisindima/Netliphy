//
//  EnvView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.04.2021.
//

import SwiftUI

struct EnvView: View {
    let env: [String: String]
    
    var footer: some View {
        Link(destination: URL(string: "https://docs.netlify.com/configure-builds/environment-variables/")!) {
            Text("footer_list_env")
        }
    }
    
    var body: some View {
        List {
            Section(footer: footer) {
                ForEach(env.sorted(by: <), id: \.key) { key, value in
                    FormItems(key, value: value)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("navigation_title_env")
    }
}
