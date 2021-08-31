//
//  View.swift
//  View
//
//  Created by Дима on 31.08.2021.
//

import SwiftUI

extension View {
    func mailSheet(isPresented: Binding<Bool>, toRecipients: [String], mailBody: String) -> some View {
        modifier(MailViewModifier(showMailView: isPresented, toRecipients: toRecipients, mailBody: mailBody))
    }
}

struct MailViewModifier: ViewModifier {
    @Binding var showMailView: Bool
    let toRecipients: [String]
    let mailBody: String
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showMailView) {
                MailComposeViewController(toRecipients: toRecipients, mailBody: mailBody)
                    .ignoresSafeArea(edges: .bottom)
            }
    }
}
