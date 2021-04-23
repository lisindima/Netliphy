//
//  FailureFormView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 22.04.2021.
//

import SwiftUI

struct FailureFormView: View {
    let errorMessage: String
    
    init(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text("title_error_state")
                    .fontWeight(.bold)
                Text(errorMessage)
                    .foregroundColor(.secondary)
                    .font(.caption2)
            }
        } icon: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
    }
}
