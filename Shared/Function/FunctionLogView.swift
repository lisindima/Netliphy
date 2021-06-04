//
//  FunctionLogView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 27.05.2021.
//

import SwiftUI

struct FunctionLogView: View {
    @StateObject private var webSocket = WebSocket()
    @State private var test = [
        FunctionLog(level: "", message: "", requestId: "", ts: 1622811287877.0, type: "start"),
        FunctionLog(level: Optional("INFO"), message: Optional("sent: 1\n"), requestId: Optional("de684c79"), ts: 1622811288061.0, type: "line"),
        FunctionLog(level: Optional("INFO"), message: Optional("failed: 0\n"), requestId: Optional("de684c79"), ts: 1622811288061.0, type: "line"),
        FunctionLog(level: Optional("INFO"), message: Optional("error: []\n"), requestId: Optional("de684c79"), ts: 1622811288061.0, type: "line"),
        FunctionLog(level: Optional("INFO"), message: Optional("Duration: 182.47 ms\tMemory Usage: 80 MB\t"), requestId: Optional("de684c79"), ts: 1622811288063.0, type: "report"),
        FunctionLog(level: Optional(""), message: Optional(""), requestId: Optional(""), ts: 1622811288371.0, type: "start"),
        FunctionLog(level: Optional("INFO"), message: Optional("sent: 1\n"), requestId: Optional("023e0cd2"), ts: 1622811288561.0, type: "line")
    ]
    
    var body: some View {
        VStack {
            if !webSocket.functionLog.isEmpty {
                ProgressView("Ждем логи")
            } else {
                ScrollView([.horizontal, .vertical]) {
                    VStack(alignment: .leading) {
                        ForEach(test, id: \.id, content: FunctionLogItems.init)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Function log")
        .onAppear(perform: webSocket.connect)
        .onDisappear(perform: webSocket.disconnect)
    }
}

struct FunctionLog: Codable, Identifiable {
    let id = UUID()
    let level: String?
    let message: String?
    let requestId: String?
    let ts: TimeInterval
    let type: String
    
    var date: Date {
        Date(timeIntervalSince1970: ts)
    }
    
    enum CodingKeys: String, CodingKey {
        case level
        case message
        case requestId = "request_id"
        case ts
        case type
    }
}

struct WebSocketAuth: Codable {
    let accessToken: String
    let accountId: String
    let functionId: String
    let siteId: String
}
