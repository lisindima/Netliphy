//
//  MailComposeViewController.swift
//  MailComposeViewController
//
//  Created by Дима on 31.08.2021.
//

import SwiftUI
import MessageUI

struct MailComposeViewController: UIViewControllerRepresentable {
    var toRecipients: [String]
    var mailBody: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(toRecipients)
        mail.setMessageBody(mailBody, isHTML: false)
        return mail
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController
        
        init(_ mailController: MailComposeViewController) {
            self.parent = mailController
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {}
}
