//
//  FeedbackView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.08.2021.
//

import SwiftUI

struct FeedbackView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var description: String = ""
    @State private var feedbackType: FeedbackType = .bug
    @State private var reproduce: Reproduce = .everyTime
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focus: Field?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("You name", text: $name)
                        .focused($focus, equals: .name)
                    TextField("You email", text: $email)
                        .focused($focus, equals: .email)
                        #if os(iOS)
                        .keyboardType(.emailAddress)
                        #endif
                }
                Section {
                    Picker(selection: $feedbackType.animation()) {
                        ForEach(FeedbackType.allCases) { feedback in
                            Text(feedback.rawValue)
                                .tag(feedback)
                        }
                    } label: {
                        Text("Feedback type")
                    }
                    .pickerStyle(.menu)
                    if feedbackType == .bug {
                        Picker(selection: $reproduce) {
                            ForEach(Reproduce.allCases) { reproduce in
                                Text(reproduce.rawValue)
                                    .tag(reproduce)
                            }
                        } label: {
                            Text("Reproduce")
                        }
                        .pickerStyle(.menu)
                    }
                }
                Section {
                    TextEditor(text: $description)
                        .focused($focus, equals: .description)
                }
                Section {
                    Button {
                        Task {
                            await submit()
                        }
                    } label: {
                        Text("Submit")
                    }
                }
            }
            .navigationTitle("New Feedback")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
        }
    }
    
    private func submit() async {
        if name.isEmpty {
            focus = .name
        } else if email.isEmpty {
            focus = .email
        } else if description.isEmpty {
            focus = .description
        } else {
           await uploadIssue()
        }
    }
    
    private func uploadIssue() async {
        let parameters = IssueParameters(
            title: "title",
            body: "body",
            assignee: "lisindima",
            labels: [
                "Feedback from App"
            ]
        )
        
        do {
            let value: Issue = try await Loader.shared.upload(for: .issue, parameters: parameters, token: .githubToken)
            print(value)
        } catch {
            print(error)
        }
    }
    
    struct IssueParameters: Encodable {
        let title: String
        let body: String
        let assignee: String
        let labels: [String]
    }
    
    enum Field: Hashable {
        case name
        case email
        case description
    }
    
    enum FeedbackType: String, Identifiable, CaseIterable {
        case bug = "Ошибка в приложении"
        case featureRequest = "Запрос функции"
        
        var id: String { rawValue }
    }

    enum Reproduce: String, Identifiable, CaseIterable {
        case everyTime = "Каждый раз"
        case sometimes = "Иногда"
        case rarely = "Редко"
        case no = "Нет"
        
        var id: String { rawValue }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedbackView()
        }
    }
}
