//
//  FormItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct FormItems: View {
    let title: String
    let value: String
    
    init(_ title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundColor(.secondary)
                .font(.footnote)
            Text(value)
                .fontWeight(.bold)
        }
        .font(.footnote)
    }
}
