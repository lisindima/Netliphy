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
    case restore(_ id: String)
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
    case plugins
    case pluginRuns(_ id: String)
    case eventDeploy(_ id: String)
    case lock(_ id: String)
    case unlock(_ id: String)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .user:
            return .makeEndpoint("user")
        case .sites:
            return .makeEndpoint("sites/?sort_by=updated_at")
        case let .site(id):
            return .makeEndpoint("sites/\(id)")
        case let .usage(id):
            return .makeEndpoint("sites/\(id)/usage")
        case let .deploys(id, items):
            return .makeEndpoint("sites/\(id)/deploys?per_page=\(items)")
        case let .deploy(id):
            return .makeEndpoint("deploys/\(id)")
        case let .retry(id):
            return .makeEndpoint("deploys/\(id)/retry")
        case let .cancel(id):
            return .makeEndpoint("deploys/\(id)/cancel")
        case let .restore(id):
            return .makeEndpoint("deploys/\(id)/restore")
        case let .log(url):
            return URL(string: "\(url).json")!
        case let .bandwidth(slug):
            return .makeEndpoint("accounts/\(slug)/bandwidth")
        case let .status(slug):
            return .makeEndpoint("\(slug)/builds/status")
        case .accounts:
            return .makeEndpoint("accounts")
        case let .members(slug):
            return .makeEndpoint("\(slug)/members?sort_by=updated_at")
        case .news:
            return URL(string: "https://app.netlify.com/.netlify/functions/notifications")!
        case let .forms(id):
            return .makeEndpoint("sites/\(id)/forms")
        case let .submission(id):
            return .makeEndpoint("submissions/\(id)")
        case let .spam(id):
            return .makeEndpoint("submissions/\(id)/spam")
        case let .submissions(formId):
            return .makeEndpoint("forms/\(formId)/submissions")
        case let .spamSubmissions(formId):
            return .makeEndpoint("forms/\(formId)/submissions?state=spam")
        case let .builds(slug):
            return .makeEndpoint("\(slug)/builds")
        case let .hooks(siteId):
            return .makeEndpoint("hooks?site_id=\(siteId)")
        case let .hook(id):
            return .makeEndpoint("hooks/\(id)")
        case let .functions(siteId):
            return .makeEndpoint("sites/\(siteId)/functions")
        case let .files(siteId):
            return .makeEndpoint("sites/\(siteId)/files")
        case .plugins:
            return URL(string: "https://list-v2--netlify-plugins.netlify.app/plugins.json")!
        case let .pluginRuns(id):
            return .makeEndpoint("deploys/\(id)/plugin_runs")
        case let .eventDeploy(id):
            return .makeEndpoint("cdp/deploys/\(id)/events")
        case let .lock(id):
            return .makeEndpoint("deploys/\(id)/lock")
        case let .unlock(id):
            return .makeEndpoint("deploys/\(id)/unlock")
        }
    }
}
