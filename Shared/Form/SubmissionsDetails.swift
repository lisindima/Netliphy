//
//  SubmissionsDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SubmissionsDetails: View {
    let submission: Submission
    
    var body: some View {
        List {
            Section {
                if let number = submission.number {
                    FormItems("Number", value: "\(number)")
                }
                if let title = submission.title {
                    FormItems("Title", value: title)
                }
                if let email = submission.email {
                    FormItems("Email", value: email)
                }
                if let name = submission.name {
                    FormItems("Name", value: name)
                }
                if let firstName = submission.firstName {
                    FormItems("First name", value: firstName)
                }
                if let lastName = submission.lastName {
                    FormItems("Last name", value: lastName)
                }
                if let company = submission.company {
                    FormItems("Company", value: company)
                }
                if let summary = submission.summary {
                    FormItems("Summary", value: summary)
                }
                if let body = submission.body {
                    FormItems("Body", value: body)
                }
            }
            Section {
                if let ip = submission.data.ip {
                    FormItems("User ip", value: ip)
                }
                if let userAgent = submission.data.userAgent {
                    FormItems("User-agent", value: userAgent)
                }
            }
            if let attachment = submission.data.attachment {
                Section {
                    Link(destination: attachment.url) {
                        FormItems("File", value: attachment.filename)
                    }
                } footer: {
                    Text("Size attachment: \(attachment.size.byteSize)")
                }
            }
        }
        .navigationTitle(submission.name ?? submission.id)
    }
}
