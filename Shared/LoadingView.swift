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
    
    init(_ loadingState: LoadingState<Value>, @ViewBuilder content: @escaping (_ value: Value) -> Content) {
        self.loadingState = loadingState
        self.content = content
    }
    
    var body: some View {
        switch loadingState {
        case let .loading(placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
        case let .failure(error):
            Text(error.localizedDescription)
        case let .success(value):
            content(value)
        }
    }
}
