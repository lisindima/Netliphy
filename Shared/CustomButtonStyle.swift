//
//  CustomButtonStyle.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.system(size: 17, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding()
        .background(Color.accentColor)
        .cornerRadius(10)
        .shadow(radius: 6)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .padding()
    }
}
