//
//  EventDeploy.swift
//  EventDeploy
//
//  Created by Дмитрий on 08.09.2021.
//

import Foundation

struct EventDeploy: Codable, Identifiable {
    let id: String
//    let user: User?
    let type: String
    let createdAt, updatedAt: Date
    let metadata: Metadata
    let path: String?
}

struct Metadata: Codable {
    let browserstackUrl: URL
    let cookies: Bool
    let language, path, ua: String
    let browser: Browser
    let device: Device
    let engine, os: Browser
    let viewport: Viewport
    let ip: String
}

struct Browser: Codable {
    let name, version: String
}

struct Device: Codable {
    let mobile: Bool
}

struct Viewport: Codable {
    let density: Double
    let height, width: Int
}

extension EventDeploy {
    static let placeholder = EventDeploy(
        id: UUID().uuidString,
//        user: nil,
        type: "placeholder",
        createdAt: Date(),
        updatedAt: Date(),
        metadata: Metadata(
            browserstackUrl: URL(string: "https://apple.com")!,
            cookies: false,
            language: "eu",
            path: "/",
            ua: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36",
            browser: Browser(
                name: "Chrome",
                version: "93.0.4577.63"
            ),
            device: Device(
                mobile: false
            ),
            engine: Browser(
                name: "Blink",
                version: "93.0.4577.63"
            ),
            os: Browser(
                name: "Mac OS",
                version: "10.15.7"
            ),
            viewport: Viewport(
                density: 2,
                height: 821,
                width: 1440
            ),
            ip: "37.23.174.230"
        ),
        path: nil
    )
}

extension Array where Element == EventDeploy {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
