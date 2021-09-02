//
//  Endpoint.swift
//  Endpoint
//
//  Created by Дмитрий on 03.09.2021.
//

import Foundation

enum Endpoint {
    case user
    case sites
    case site(_ id: String)
    case usage(_ id: String)
    case deploys(_ id: String, items: Int = 100)
    case deploy(_ id: String)
    case retry(_ id: String)
    case cancel(_ id: String)
    case log(url: String)
    case bandwidth(_ slug: String)
    case status(_ slug: String)
    case accounts
    case members(_ slug: String)
    case news
    case forms(_ id: String)
    case submission(_ id: String)
    case spam(_ id: String)
    case submissions(_ formId: String)
    case spamSubmissions(_ formId: String)
    case builds(_ slug: String)
    case hooks(_ siteId: String)
    case hook(_ id: String)
    case functions(_ siteId: String)
    case files(_ siteId: String)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user:
            return .makeForEndpoint("user")
        case .sites:
            return .makeForEndpoint("sites/?sort_by=updated_at")
        case let .site(id):
            return .makeForEndpoint("sites/\(id)")
        case let .usage(id):
            return .makeForEndpoint("sites/\(id)/usage")
        case let .deploys(id, items):
            return .makeForEndpoint("sites/\(id)/deploys?per_page=\(items)")
        case let .deploy(id):
            return .makeForEndpoint("deploys/\(id)")
        case let .retry(id):
            return .makeForEndpoint("deploys/\(id)/retry")
        case let .cancel(id):
            return .makeForEndpoint("deploys/\(id)/cancel")
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
        case let .forms(id):
            return .makeForEndpoint("sites/\(id)/forms")
        case let .submission(id):
            return .makeForEndpoint("submissions/\(id)")
        case let .spam(id):
            return .makeForEndpoint("submissions/\(id)/spam")
        case let .submissions(formId):
            return .makeForEndpoint("forms/\(formId)/submissions")
        case let .spamSubmissions(formId):
            return .makeForEndpoint("forms/\(formId)/submissions?state=spam")
        case let .builds(slug):
            return .makeForEndpoint("\(slug)/builds")
        case let .hooks(siteId):
            return .makeForEndpoint("hooks?site_id=\(siteId)")
        case let .hook(id):
            return .makeForEndpoint("hooks/\(id)")
        case let .functions(siteId):
            return .makeForEndpoint("sites/\(siteId)/functions")
        case let .files(siteId):
            return .makeForEndpoint("sites/\(siteId)/files")
        }
    }
}
