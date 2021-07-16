//
//  FormItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct FormItems: View {
    let title: LocalizedStringKey
    let value: String?
    
    init(_ title: LocalizedStringKey, value: String?) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        if let value = value {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .foregroundColor(.secondary)
                Text(value)
                    .fontWeight(.bold)
            }
            .font(.footnote)
        }
    }
}
