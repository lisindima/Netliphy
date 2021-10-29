//
//  SubmissionsDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import SwiftUI

struct SubmissionsDetails: View {
    let submission: Submission
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert: Bool = false
    
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
        .navigationTitle(submission.id)
        .toolbar {
            Menu {
//                Button {
//                    Task {
//                        await markAsSpam()
//                    }
//                } label: {
//                    Label("Mark as spam", systemImage: "archivebox")
//                }
                Button(role: .destructive) {
                    Task {
                        await deleteSubmission()
                    }
                } label: {
                    Label("Delete submission", systemImage: "trash")
                }
            } label: {
                Label("Open Menu", systemImage: "ellipsis")
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("An error occurred during the execution of the action, check the Internet connection and the rights to this action.")
        }
    }
    
    @MainActor
    private func markAsSpam() async {
        do {
            try await Loader.shared.response(for: .spam(submission.id), httpMethod: .put)
            dismiss()
        } catch {
            showAlert = true
            print(error)
        }
    }
    
    @MainActor
    private func deleteSubmission() async {
        do {
            try await Loader.shared.response(for: .submission(submission.id), httpMethod: .delete)
            dismiss()
        } catch {
            showAlert = true
            print(error)
        }
    }
}
