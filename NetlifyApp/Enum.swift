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
    case sites
    case deploys(_ siteId: String)
}

extension Endpoint {
    static let api = API()
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user:
            return .makeForEndpoint("user")
        case .sites:
            return .makeForEndpoint("sites")
        case let .deploys(siteId):
            return .makeForEndpoint("sites/\(siteId)/deploys")
        }
    }
}
