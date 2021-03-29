//
//  FormItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct FormItems: View {
    var title: String
    var value: String
    
    init(_ title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.footnote)
    }
}
