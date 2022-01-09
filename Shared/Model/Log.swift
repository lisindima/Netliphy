//
//  Log.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import SwiftUI

struct Log: Codable, Identifiable {
    var id = UUID()
    let message: String
    let date: Date
    let type: String?
    
    var colorMessage: Color? {
        if message.contains("success") {
            return Color.green
        }
        if message.contains("warning") {
            return Color.orange
        }
        if message.contains("error") {
            return Color.red
        }
        if message.contains("info") {
            return Color.blue
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case message = "log"
        case date = "ts"
        case type
    }
}
