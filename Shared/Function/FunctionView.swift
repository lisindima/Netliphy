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
                FormItems("Runtime", value: function.runtime)
                FormItems("Function create", value: function.createdAt.siteDate)
                Link("Open function", destination: function.endpoint)
            }
            Section {
                NavigationLink(destination: Text("log")) {
                    Label("Function log", systemImage: "rectangle.and.text.magnifyingglass")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(function.name)
    }
}

