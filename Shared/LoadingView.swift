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
    let error: ErrorView
    let content: (_ value: Value) -> Content
    
    var body: some View {
        switch loadingState {
        case let .loading(placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
        case let .success(value):
            content(value)
        case .failure:
            error
        case .empty:
            empty
        }
    }
}

struct ErrorStateView: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("title_error_state")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Text("subTitle_error_state")
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
