//
//  FunctionItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import SwiftUI

struct FunctionItems: View {
    let function: Function
    
    var body: some View {
        NavigationLink(destination: FunctionView(function: function)) {
            VStack(alignment: .leading) {
                Group {
                    Text(function.name)
                        .fontWeight(.bold)
                }
                .font(.footnote)
                .lineLimit(1)
                HStack {
                    Text(function.createdAt, style: .relative) + Text("site_items_ago")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
    }
}