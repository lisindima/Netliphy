//
//  FunctionView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import SwiftUI

struct FunctionView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var webSocket = WebSocket()
    
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
                if webSocket.functionLog.isEmpty {
                    Label {
                        Text("progress_view_title_function")
                    } icon: {
                        ProgressView()
                            .tint(.accentColor)
                    }
                } else {
                    ScrollView([.horizontal, .vertical]) {
                        VStack(alignment: .leading) {
                            ForEach(webSocket.functionLog, id: \.id, content: FunctionLogItems.init)
                        }
                    }
                }
            }
        }
        .navigationTitle("navigation_title_function")
        .onAppear {
            webSocket.connect(
                auth: WebSocketAuth(
                    accessToken: accessToken,
                    accountId: function.account,
                    functionId: function.id,
                    siteId: siteId
                )
            )
        }
        .onDisappear(perform: webSocket.disconnect)
    }
    
    private var accessToken: String {
        var token = sessionStore.accessToken
        token.removeFirst(7)
        return token
    }
}
