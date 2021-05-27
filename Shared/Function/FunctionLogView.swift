//
//  FunctionLogView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 27.05.2021.
//

import SwiftUI

struct FunctionLogView: View {
    @State private var webSocketTask: URLSessionWebSocketTask?
    @State private var functionLog: [FunctionLog] = []
    
    var body: some View {
        List {
            ForEach(functionLog, id: \.self) { log in
                Text("\(log.ts)")
            }
        }
        .navigationTitle("Function log")
        .onAppear(perform: connect)
        .onDisappear(perform: disconnect)
    }
    
    func connect() {
        let url = URL(string: "wss://socketeer.services.netlify.com/function/logs")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.receive(completionHandler: onReceive)
        webSocketTask?.resume()
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let auth = WebSocketAuth(
            accessToken: "_8KwmZ6rPGi-gio0EeSweXuQNNa5y8R1rLeG2uOeWjM",
            accountId: "008585217041",
            functionId: "28cebd9df8f2856f91e7b7725f9555bcd454de3125d0c573a4590ec11ab9d201",
            siteId: "293ac253-ed75-48c6-8cbb-c5488fbb720c"
        )
        
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
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        if case let .success(value) = incoming {
            print(value)
            if case let .string(text) = value {
                guard let data = text.data(using: .utf8),
                      let log = try? JSONDecoder().decode(FunctionLog.self, from: data)
                else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.functionLog.append(log)
                }
            }
        }
        else if case let .failure(error) = incoming {
            print("Error", error)
        }
    }
}

struct FunctionLog: Codable, Hashable {
    let level: String?
    let message: String?
    let requestId: String?
    let ts: Int
    let type: String
}

struct WebSocketAuth: Codable {
    let accessToken: String
    let accountId: String
    let functionId: String
    let siteId: String
}
