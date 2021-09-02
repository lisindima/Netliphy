//
//  File.swift
//  File
//
//  Created by Дмитрий on 01.09.2021.
//

import Foundation

struct File: Codable, Identifiable {
    let id, path, sha: String
    let mimeType: String
    let size: Int64
    let siteId: String
    let deployId: String
}

enum MIMEType: String, Codable {
    case applicationXML = "application/xml"
    case applicationPDF = "application/pdf"
    case applicationJSON = "application/json"
    case applicationJavascript = "application/javascript"
    case applicationOctetStream = "application/octet-stream"
    case applicationXYAML = "application/x-yaml"
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case imageSVGXML = "image/svg+xml"
    case textCSS = "text/css"
    case textHTML = "text/html"
    case textPlain = "text/plain"
}

extension File {
    static let placeholder = File(
        id: UUID().uuidString,
        path: "placeholder",
        sha: "placeholder",
        mimeType: "placeholder",
        size: 100,
        siteId: "placeholder",
        deployId: "placeholder"
    )
}

extension Array where Element == File {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 3)
}
