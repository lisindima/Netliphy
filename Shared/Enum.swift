//
//  Enum.swift
//  Netliphy
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
    case deploy(siteId: String, deploy: String)
    case log(url: String)
    case bandwidth(slug: String)
    case status(slug: String)
    case accounts
    case forms(siteId: String)
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
        case let .deploy(siteId, deploy):
            return .makeForEndpoint("sites/\(siteId)/deploys/\(deploy)")
        case let .log(url):
            return URL(string: "\(url).json")!
        case let .bandwidth(slug):
            return .makeForEndpoint("accounts/\(slug)/bandwidth")
        case let .status(slug):
            return .makeForEndpoint("\(slug)/builds/status")
        case .accounts:
            return .makeForEndpoint("accounts")
        case let .forms(siteId):
            return .makeForEndpoint("sites/\(siteId)/forms")
        }
    }
}
