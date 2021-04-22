//
//  LoadingView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct LoadingView<Value, Content, EmptyView, ErrorView>: View where Content: View, EmptyView: View, ErrorView: View {
    @Binding var loadingState: LoadingState<Value>
    
    let empty: EmptyView
    let failure: (_ error: Error) -> ErrorView
    let content: (_ value: Value) -> Content
    
    var body: some View {
        switch loadingState {
        case let .loading(placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
        case let .success(value):
            content(value)
        case let .failure(error):
            failure(error)
        case .empty:
            empty
        }
    }
}

struct ErrorStateView: View {
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

struct EmptyStateView: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(subTitle)
                .foregroundColor(.secondary)
        }
    }
}
