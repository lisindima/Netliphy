//
//  EventDeploy.swift
//  EventDeploy
//
//  Created by Дмитрий on 08.09.2021.
//

import Foundation

struct EventDeploy: Codable, Identifiable {
    let id: String
    let user: User
    let type: TypeEvent
    let createdAt, updatedAt: Date
    let metadata: Metadata
    let path: String?
    
    var info: String {
        metadata.browser.name + " " + metadata.browser.version + " on " + metadata.os.name + " " + metadata.os.version
    }
    var browser: String {
        metadata.browser.name + " " + metadata.browser.version
    }
    var engine: String {
        metadata.engine.name + " " + metadata.engine.version
    }
    var os: String {
        metadata.os.name + " " + metadata.os.version
    }
    var viewport: String {
        "\(metadata.viewport.width)" + " x " + "\(metadata.viewport.height)" + " @" + "\(metadata.viewport.density)" + "x"
    }
    
    struct User: Codable {
        let fullName: String?
        let avatar: URL?
        let email: String?
        let createdAt: Date?
        let connectedAccounts: [String: String]?
        
        var name: String {
            fullName ?? "Anonymous"
        }
    }
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

enum TypeEvent: String, Codable {
    case view = "view"
    case comment = "comment"
}

extension EventDeploy {
    static let placeholder = EventDeploy(
        id: UUID().uuidString,
        user: User(
            fullName: "Anonymous",
            avatar: nil,
            email: nil,
            createdAt: Date(),
            connectedAccounts: nil
        ),
        type: .view,
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
