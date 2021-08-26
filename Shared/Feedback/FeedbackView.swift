//
//  FeedbackView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.08.2021.
//

import SwiftUI

struct FeedbackView: View {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var feedbackType: FeedbackType = .bug
    @State private var reproduce: Reproduce = .everyTime
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focus: Field?
    
    var body: some View {
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
                if feedbackType == .bug {
                    Picker(selection: $reproduce) {
                        ForEach(Reproduce.allCases) { reproduce in
                            Text(reproduce.rawValue)
                                .tag(reproduce)
                        }
                    } label: {
                        Text("Reproduce")
                    }
                }
            }
            Section {
                TextField("Title", text: $title)
                    .focused($focus, equals: .title)
            }
            Section {
                TextEditor(text: $description)
                    .focused($focus, equals: .description)
            } footer: {
                Text("Styling with Markdown is supported")
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
        .navigationTitle("Feedback")
        .onAppear(perform: autofillUser)
    }
    
    private func autofillUser() {
        name = ""
        email = ""
        if let user = accounts.first?.user {
            if let name = user.fullName {
                self.name = name
            }
            if let email = user.email {
                self.email = email
            }
        }
    }
    
    private func submit() async {
        if name.isEmpty {
            focus = .name
        } else if email.isEmpty {
            focus = .email
        } else if title.isEmpty {
            focus = .title
        } else if description.isEmpty {
            focus = .description
        } else {
           await uploadIssue()
        }
    }
    
    private func parameters() -> IssueParameters {
        let device = UIDevice()
        
        let info = """
            **Device:** \(device.name)
            **OS Version:** \(device.systemName) \(device.systemVersion)
            **Name:** \(name)
            **Email:** \(email)
        """
        
        var parameters = IssueParameters(
            title: title,
            body: description,
            assignee: "lisindima",
            labels: [
                "feedback from the application"
            ]
        )
        
        parameters.labels.append(feedbackType.githubLabel)
        parameters.body.append(info)
        return parameters
    }
    
    private func uploadIssue() async {
        do {
            let value: Issue = try await Loader.shared.upload(for: .issue, parameters: parameters(), token: Constant.githubToken)
            print(value)
        } catch {
            print(error)
        }
    }
    
    struct IssueParameters: Encodable {
        let title: String
        var body: String
        let assignee: String
        var labels: [String]
    }
    
    enum Field: Hashable {
        case name
        case email
        case title
        case description
    }
    
    enum FeedbackType: String, Identifiable, CaseIterable {
        case bug = "Ошибка в приложении"
        case enhancement = "Запрос функции"
        
        var id: String { rawValue }
        
        var githubLabel: String {
            switch self {
            case .bug:
                return "bug"
            case .enhancement:
                return "enhancement"
            }
        }
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
        FeedbackView()
    }
}
