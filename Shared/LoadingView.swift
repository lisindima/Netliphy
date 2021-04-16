//
//  LoadingView.swift
//  Netliphy
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
    
    private func retry() {
        load()
    }
    
    var body: some View {
        switch loadingState {
        case let .loading(placeholder):
            content(placeholder)
                .redacted(reason: .placeholder)
                .disabled(true)
                .onAppear(perform: load)
        case let .success(value):
            content(value)
                .onAppear(perform: load)
        case let .failure(error):
            VStack {
                Spacer()
                Text("title_error_state")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Text(error.localizedDescription)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                Button("button_error_retry", action: retry)
                    .buttonStyle(CustomButtonStyle())
            }
        case .empty:
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text(subTitle)
                    .foregroundColor(.secondary)
            }
            .onAppear(perform: load)
        }
    }
}
