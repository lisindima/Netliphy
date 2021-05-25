//
//  FunctionView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import SwiftUI

struct FunctionView: View {
    let function: Function
    
    var body: some View {
        List {
            Section {
                FormItems("Name", value: function.name)
            }
            Section {
                Link("Open function", destination: function.endpoint)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(function.name)
    }
}

