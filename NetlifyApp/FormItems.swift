//
//  FormItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct FormItems: View {
    var title: LocalizedStringKey
    var value: String
    
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
