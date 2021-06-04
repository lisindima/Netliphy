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
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading) {
                ForEach(test, id: \.id, content: FunctionLogItems.init)
            }
        }
        .navigationTitle("Function log")
        .onAppear(perform: webSocket.connect)
        .onDisappear(perform: webSocket.disconnect)
    }
}

struct FunctionLogItems: View {
    let log: FunctionLog
    
    var body: some View {
        if log.type != "start" {
            HStack {
                Text(log.date.logDate)
                if let requestId = log.requestId {
                    Text(requestId)
                }
                if let level = log.level {
                    Text(level)
                }
                if let message = log.message {
                    Text(message)
                }
            }
            .font(.system(.caption2, design: .monospaced))
        }
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

class WebSocket: ObservableObject {
    @Published private(set) var functionLog: [FunctionLog] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    let auth = WebSocketAuth(
        accessToken: "_8KwmZ6rPGi-gio0EeSweXuQNNa5y8R1rLeG2uOeWjM",
        accountId: "008585217041",
        functionId: "28cebd9df8f2856f91e7b7725f9555bcd454de3125d0c573a4590ec11ab9d201",
        siteId: "293ac253-ed75-48c6-8cbb-c5488fbb720c"
    )
    
    func connect() {
        if webSocketTask == nil {
            disconnect()
        }
        
        let url = URL(string: "wss://socketeer.services.netlify.com/function/logs")!
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        sendMessage()
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        functionLog.removeAll()
    }
    
    private func sendMessage() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .sortedKeys
        
        guard let data = try? encoder.encode(auth) else { return }
        guard let jsonString = String(bytes: data, encoding: .utf8) else { return }
        print(jsonString)
        
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive {[weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
            case .success(.string(let str)):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FunctionLog.self, from: Data(str.utf8))
                    DispatchQueue.main.async{
                        self?.functionLog.append(result)
                        print(result)
                    }
                } catch {
                    print("error is \(error.localizedDescription)")
                }
                self?.receiveMessage()
                
            default:
                print("default")
            }
        }
    }
}
