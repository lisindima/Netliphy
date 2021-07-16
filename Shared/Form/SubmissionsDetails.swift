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
                FormItems("Number", value: "\(submission.number)")
                FormItems("Title", value: submission.title)
                FormItems("Email", value: submission.email)
                FormItems("Name", value: submission.name)
                FormItems("First name", value: submission.firstName)
                FormItems("Last name", value: submission.lastName)
                FormItems("Company", value: submission.company)
                FormItems("Summary", value: submission.summary)
                FormItems("Body", value: submission.body)
            }
            Section {
                FormItems("User ip", value: submission.data.ip)
                FormItems("User-agent", value: submission.data.userAgent)
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
