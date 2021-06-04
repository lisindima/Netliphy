//
//  String.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 14.03.2021.
//

import Foundation

extension String {
    static let callbackURLScheme = "netlifyhub"
    
    var withoutTags: String {
        let regex = try! NSRegularExpression(pattern: "\u{1B}(?:[@-Z\\-_]|\\[[0-?]*[ -/]*[@-~])")
        let range = NSRange(startIndex ..< endIndex, in: self)

        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    var withoutNewLines: String {
        components(separatedBy: .newlines).joined()
    }
}
