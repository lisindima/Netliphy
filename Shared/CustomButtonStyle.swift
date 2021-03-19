//
//  CustomButtonStyle.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .black : .white)
            Spacer()
        }
        .padding()
        .background(Color.accentColor)
        .cornerRadius(8)
        .shadow(radius: 6)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .padding()
    }
}
