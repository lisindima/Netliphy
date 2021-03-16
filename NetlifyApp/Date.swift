//
//  Date.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import Foundation

extension Date {
    var logDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
