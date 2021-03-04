//
//  LoadingView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct LoadingView<Value, Content>: View where Content: View {
    @Binding var loadingState: LoadingState<Value>
    
    var title: LocalizedStringKey = ""
    var subTitle: LocalizedStringKey = ""
    var load: () -> Void
    var content: (_ value: Value) -> Content
    
    private func retryHandler() {
        loadingState = .loading
        load()
    }
    
    var body: some View {
        switch loadingState {
        case .loading:
            ProgressView()
                .onAppear(perform: load)
        case let .success(value):
            content(value)
        case let .failure(error):
            Text(error.localizedDescription)
            Button("Повторить", action: retryHandler)
        case .empty:
            Text(title)
            Text(subTitle)
                .onAppear(perform: load)
        }
    }
}
