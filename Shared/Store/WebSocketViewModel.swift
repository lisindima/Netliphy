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
    
    func connect(auth: WebSocketAuth) {
        if webSocketTask == nil {
            disconnect()
        }
        
        let url = URL(string: "wss://socketeer.services.netlify.com/function/logs")!
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        sendMessage(auth: auth)
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    private func sendMessage(auth: WebSocketAuth) {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .sortedKeys
        
        guard let data = try? encoder.encode(auth) else { return }
        guard let jsonString = String(bytes: data, encoding: .utf8) else { return }
        
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [self] result in
            switch result {
            case let .failure(error):
                print("Error in receiving message: \(error)")
            case let .success(.string(str)):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FunctionLog.self, from: Data(str.utf8))
                    functionLog.append(result)
                } catch {
                    print("error is \(error.localizedDescription)")
                }
                receiveMessage()
                
            default:
                print("default")
            }
        }
    }
}
