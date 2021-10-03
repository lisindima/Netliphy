//
//  Date.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 16.03.2021.
//

import Foundation

extension TimeInterval {
    var convertToFullTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter.string(from: self) ?? ""
    }
}

extension Int {
    var convertToMinute: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .minute
        formatter.unitsStyle = .full
        return formatter.string(from: TimeInterval(self * 60)) ?? ""
    }
}

extension DateFormatter {
    static var netlifyFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }
    
    static var iso8601: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
}
