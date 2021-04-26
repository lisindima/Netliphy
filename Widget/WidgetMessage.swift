//
//  WidgetMessage.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 24.04.2021.
//

import SwiftUI

struct WidgetMessage: View {
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .fontWeight(.bold)
            Text(description)
                .font(.caption2)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}
