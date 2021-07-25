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
    
    @State private var showFilter: Bool = false
    
    let function: Function
    let siteId: String
    
    var body: some View {
        List {
            Section {
                FormItems("Name", value: function.name)
                FormItems("Runtime", value: function.runtime)
                FormItems("Function create", value: function.createdAt.formatted())
                Link("Open function", destination: function.endpoint)
            }
            Section {
                if viewModel.functionLog.isEmpty {
                    Label {
                        Text("We are waiting for new logs")
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
        .navigationTitle("Function")
        #if !os(watchOS)
        .toolbar {
            Button {
                showFilter = true
            } label: {
                Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
            }
        }
        .sheet(isPresented: $showFilter) {
            FunctionLogFilterView()
        }
        #endif
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
