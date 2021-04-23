//
//  FailureView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.04.2021.
//

import SwiftUI

struct FailureView: View {
    let errorMessage: String
    let action: () -> Void
    
    init(_ errorMessage: String, action: @escaping () -> Void) {
        self.errorMessage = errorMessage
        self.action = action
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("title_error_state")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text(errorMessage)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button("button_error_retry", action: action)
                .buttonStyle(CustomButtonStyle())
        }
    }
}
