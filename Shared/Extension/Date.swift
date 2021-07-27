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

extension Formatter {
    static var iso8601withFractionalSeconds: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }

    static var iso8601: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
