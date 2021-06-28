//
//  EnvView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.04.2021.
//

import SwiftUI

struct EnvView: View {
    let env: [String: String]
    
    var body: some View {
        List {
            Section {
                ForEach(env.sorted(by: <), id: \.key) { key, value in
                    FormItems(key, value: value)
                }
            }
        }
        .navigationTitle("Environment variables")
    }
}
