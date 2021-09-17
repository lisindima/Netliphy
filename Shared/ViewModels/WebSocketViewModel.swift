//
//  WebSocketViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.06.2021.
//

import SwiftUI

@MainActor
class WebSocketViewModel: ObservableObject {
    @Published private(set) var functionLog: [FunctionLog] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect(message: WebSocketMessage) async {
        if webSocketTask == nil {
            disconnect()
        }
        
        let url = URL(string: "wss://socketeer.services.netlify.com/function/logs")!
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
    
        functionLog.removeAll()
        
        await sendMessage(message: message)
        await receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func sendMessage(message: WebSocketMessage) async {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .sortedKeys
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(message) else { return }
        guard let jsonString = String(bytes: data, encoding: .utf8) else { return }
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        
        do {
            try await webSocketTask?.send(message)
        } catch {
            print("WebSocket couldn’t send message because: \(error)")
        }
    }
    
    private func receiveMessage() async {
        let decoder = JSONDecoder()
        do {
            let message = try await webSocketTask?.receive()
            switch message {
            case let .string(str):
                let log = try decoder.decode(FunctionLog.self, from: Data(str.utf8))
                functionLog.append(log)
            default:
                print("default")
            }
            await receiveMessage()
        } catch {
            print("error is \(error.localizedDescription)")
        }
    }
}
