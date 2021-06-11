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

enum LoaderError: Error {
    case invalidServerResponse
}

enum LoadingState<Value> {
    case loading(_ placeholder: Value)
    case empty
    case success(_ value: Value)
    case failure(_ error: Error)
}

enum Endpoint {
    case user
    case sites
    case site(siteId: String)
    case deploys(siteId: String, items: Int = 100)
    case deploy(deployId: String)
    case retry(deployId: String)
    case cancel(deployId: String)
    case log(url: String)
    case bandwidth(slug: String)
    case status(slug: String)
    case accounts
    case members(slug: String)
    case news
    case forms(siteId: String)
    case submissions(formId: String)
    case builds(slug: String)
    case hooks(siteId: String)
    case hook(hookId: String)
    case functions(siteId: String)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user:
            return .makeForEndpoint("user")
        case .sites:
            return .makeForEndpoint("sites/?sort_by=updated_at")
        case let .site(siteId):
            return .makeForEndpoint("sites/\(siteId)")
        case let .deploys(siteId, items):
            return .makeForEndpoint("sites/\(siteId)/deploys?per_page=\(items)")
        case let .deploy(deployId):
            return .makeForEndpoint("deploys/\(deployId)")
        case let .retry(deployId):
            return .makeForEndpoint("deploys/\(deployId)/retry")
        case let .cancel(deployId):
            return .makeForEndpoint("deploys/\(deployId)/cancel")
        case let .log(url):
            return URL(string: "\(url).json")!
        case let .bandwidth(slug):
            return .makeForEndpoint("accounts/\(slug)/bandwidth")
        case let .status(slug):
            return .makeForEndpoint("\(slug)/builds/status")
        case .accounts:
            return .makeForEndpoint("accounts")
        case let .members(slug):
            return .makeForEndpoint("\(slug)/members?sort_by=updated_at")
        case .news:
            return URL(string: "https://app.netlify.com/.netlify/functions/notifications")!
        case let .forms(siteId):
            return .makeForEndpoint("sites/\(siteId)/forms")
        case let .submissions(formId):
            return .makeForEndpoint("forms/\(formId)/submissions")
        case let .builds(slug):
            return .makeForEndpoint("\(slug)/builds")
        case let .hooks(siteId):
            return .makeForEndpoint("hooks?site_id=\(siteId)")
        case let .hook(hookId):
            return .makeForEndpoint("hooks/\(hookId)")
        case let .functions(siteId):
            return .makeForEndpoint("sites/\(siteId)/functions")
        }
    }
}

enum DeployStateFilter: Hashable {
    case allState
    case filteredByState(state: DeployState)
}

enum BuildStateFilter: Hashable {
    case allState
    case filteredByState(state: BuildState)
}

enum SiteNameFilter: Hashable {
    case allSites
    case filteredBySite(site: String)
}
