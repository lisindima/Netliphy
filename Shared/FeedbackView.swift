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
    @State private var reproduce: Reproduce = .yesEveryTime
    
    @FocusState private var focus: Field?
    
    var body: some View {
        Form {
            Section {
                TextField("You name", text: $name)
                    .focused($focus, equals: .name)
                TextField("You email", text: $email)
                    .keyboardType(.emailAddress)
                    .focused($focus, equals: .email)
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
                TextEditor(text: $description)
                    .focused($focus, equals: .description)
                    .frame(height: 100)
            }
            Section {
                Button("Submit", action: submit)
            }
        }
        .navigationTitle("Feedback")
    }
    
    func submit() {
        if name.isEmpty {
            focus = .name
        } else if email.isEmpty {
            focus = .email
        } else if description.isEmpty {
            focus = .description
        }
    }
    
    enum Field: Hashable {
        case name
        case email
        case description
    }
    
    enum FeedbackType: String, Identifiable, CaseIterable {
        case bug = "Ошибка в приложении"
        case featureRequest = "Запрос функции"
        case other = "Другое"
        
        var id: String { rawValue }
    }

    enum Reproduce: String, Identifiable, CaseIterable {
        case yesEveryTime = "Да, каждый раз"
        case yesSometimes = "Да, иногда"
        case yesRarely = "Да, редко"
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
