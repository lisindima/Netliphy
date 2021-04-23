//
//  LoadingView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct LoadingView<Value, Content, Empty, Failure>: View where Content: View, Empty: View, Failure: View {
    @Binding var loadingState: LoadingState<Value>
    
    let empty: Empty
    let failure: (_ error: Error) -> Failure
    let content: (_ value: Value) -> Content
    
    init(
        loadingState: Binding<LoadingState<Value>>,
        empty: Empty,
        failure: @escaping (_ error: Error) -> Failure,
        content: @escaping (_ value: Value) -> Content
    ) {
        _loadingState = loadingState
        self.empty = empty
        self.failure = failure
        self.content = content
    }
    
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

extension LoadingView where Empty == EmptyView {
    init(
        loadingState: Binding<LoadingState<Value>>,
        failure: @escaping (_ error: Error) -> Failure,
        content: @escaping (_ value: Value) -> Content
    ) {
        self.init(
            loadingState: loadingState,
            empty: EmptyView(),
            failure: failure,
            content: content
        )
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
