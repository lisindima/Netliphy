//
//  Button.swift
//  Button
//
//  Created by Дмитрий on 07.09.2021.
//

import SwiftUI

struct PrimatyButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                configuration.label
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(colorScheme == .dark ? .black : .white)
        .font(.body.weight(.bold))
        .background(
            configuration.isPressed
            ? Color.accentColor.opacity(0.8)
            : Color.accentColor
        )
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                configuration.label
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.accentColor)
        .font(.body.weight(.bold))
    }
}

struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                configuration.label
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .font(.body.weight(.bold))
        .background(
            configuration.isPressed
            ? Color.red.opacity(0.8)
            : Color.red
        )
    }
}

struct PrimaryButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PrimatyButton())
            .listRowInsets(EdgeInsets())
    }
}

struct SecondaryButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(SecondaryButton())
            .listRowInsets(EdgeInsets())
    }
}


struct RedButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(RedButton())
            .listRowInsets(EdgeInsets())
    }
}
