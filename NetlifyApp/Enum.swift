//
//  Enum.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}

enum ApiError: Error {
    case uploadFailed(_ error: Error)
    case decodeFailed(_ error: Error)
}

enum LoadingState<Value> {
    case loading
    case empty
    case success(_ value: Value)
    case failure(_ error: Error)
}

enum Endpoint {
    case user
    case sites(siteId: String = "")
    case deploys(siteId: String, items: Int = 100)
    case log(url: String)
}

extension Endpoint {
    static let api = API()
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user:
            return .makeForEndpoint("user")
        case let .sites(siteId):
            return .makeForEndpoint("sites/\(siteId)")
        case let .deploys(siteId, items):
            return .makeForEndpoint("sites/\(siteId)/deploys?per_page=\(items)")
        case let .log(url):
            return URL(string: "\(url).json")!
        }
    }
}
