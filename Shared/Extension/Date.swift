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
}

@propertyWrapper
struct ISO8601Date {
    let wrappedValue: Date
}

extension ISO8601Date: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = ISO8601DateFormatter().date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        wrappedValue = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let string = ISO8601DateFormatter().string(from: wrappedValue)
        try container.encode(string)
    }
}
