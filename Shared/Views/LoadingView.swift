//
//  LoadingView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct LoadingView<Value, Content>: View where Content: View {
    let loadingState: LoadingState<Value>
    let content: (_ value: Value) -> Content
    
    init(
        _ loadingState: LoadingState<Value>,
        @ViewBuilder content: @escaping (_ value: Value) -> Content
    ) {
        self.loadingState = loadingState
        self.content = content
    }
    
    var body: some View {
        switch loadingState {
        case let .placeholder(placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
        case .loading:
            ProgressView()
        case let .success(value):
            content(value)
        case let .failure(message):
            VStack(spacing: 16) {
                Text("Error")
                    .font(.title.weight(.bold))
                Text(message.localizedDescription)
                    .font(.subheadline)
            }
            .foregroundColor(.secondary)
        }
    }
}

enum LoadingState<Value> {
    case placeholder(_ placeholder: Value)
    case loading
    case success(_ value: Value)
    case failure(_ error: Error)
}
