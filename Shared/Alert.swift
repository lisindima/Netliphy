//
//  Alert.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.03.2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: LocalizedStringKey = "Error"
    var message: LocalizedStringKey
    var action: (() -> Void)? = {}
}

struct CustomAlert: ViewModifier {
    @Binding var item: AlertItem?

    func body(content: Content) -> some View {
        content
            .alert(item: $item) { item in
                alert(title: item.title, message: item.message, action: item.action)
            }
    }
}

extension ViewModifier {
    func alert(title: LocalizedStringKey, message: LocalizedStringKey, action: (() -> Void)? = {}) -> Alert {
        Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: .cancel(Text("Close"), action: action)
        )
    }
}

extension View {
    func customAlert(item: Binding<AlertItem?>) -> some View {
        modifier(CustomAlert(item: item))
    }
}
