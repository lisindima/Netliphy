//
//  WebSocket.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.06.2021.
//

import Combine
import Foundation

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
        webSocketTask?.receive { [weak self] result in
            switch result {
            case let .failure(error):
                print("Error in receiving message: \(error)")
            case let .success(.string(str)):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FunctionLog.self, from: Data(str.utf8))
                    DispatchQueue.main.async {
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
