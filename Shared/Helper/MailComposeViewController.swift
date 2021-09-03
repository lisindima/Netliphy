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
    var subject: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(toRecipients)
        mail.setSubject(subject)
        return mail
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController
        
        init(_ mailController: MailComposeViewController) {
            self.parent = mailController
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {}
}
