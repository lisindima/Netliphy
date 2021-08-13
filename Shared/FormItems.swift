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
                    .fontWeight(.bold)
                    .font(.system(size: 10))
                    .textCase(.uppercase)
                Text(value)
                    .fontWeight(.semibold)
                    .font(.footnote)
            }
        }
    }
}

struct FormItems_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FormItems("Test title", value: "Test value")
            FormItems("Test title", value: "Test value")
            FormItems("Test title", value: "Test value")
            FormItems("Test title", value: "Test value")
        }
    }
}
