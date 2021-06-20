//
//  LoadingView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct LoadingView<Value, Content, Failure>: View where Content: View, Failure: View {
    let loadingState: LoadingState<Value>
    let failure: (_ error: Error) -> Failure
    let content: (_ value: Value) -> Content
    
    init(
        loadingState: LoadingState<Value>,
        failure: @escaping (_ error: Error) -> Failure,
        @ViewBuilder content: @escaping (_ value: Value) -> Content
    ) {
        self.loadingState = loadingState
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
        }
    }
}
