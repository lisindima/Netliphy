//
//  FunctionView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import SwiftUI

struct FunctionView: View {
    @StateObject private var viewModel = WebSocketViewModel()
    
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    let function: Function
    let siteId: String
    
    var body: some View {
        List {
            Section {
                FormItems("Name", value: function.name)
                FormItems("Runtime", value: function.runtime)
                FormItems("Function create", value: function.createdAt.formatted())
                Link("link_title_open_function", destination: function.endpoint)
            }
            Section {
                if viewModel.functionLog.isEmpty {
                    Label {
                        Text("progress_view_title_function")
                    } icon: {
                        ProgressView()
                            .tint(.accentColor)
                    }
                } else {
                    ScrollView([.horizontal, .vertical]) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.functionLog, id: \.id, content: FunctionLogItems.init)
                        }
                    }
                }
            }
        }
        .navigationTitle("navigation_title_function")
        .onAppear {
            viewModel.connect(
                auth: WebSocketAuth(
                    accessToken: accounts.first?.token,
                    accountId: function.account,
                    functionId: function.id,
                    siteId: siteId
                )
            )
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
}
