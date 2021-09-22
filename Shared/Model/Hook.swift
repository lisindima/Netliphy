//
//  Hook.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.05.2021.
//

import Foundation

struct Hook: Codable, Identifiable {
    let id, siteId: String
    let formId, formName: String?
    let userId: String
    let type: String
    let event: HookEvent
    let data: [String: String?]
    let success: Bool?
    let createdAt, updatedAt: Date
    let actor: HookActor
    let disabled: Bool?
    let restricted: Bool
}

enum HookEvent: String, Codable {
    case deployCreated = "deploy_created"
    case deployBuilding = "deploy_building"
    case deployFailed = "deploy_failed"
    case deployRequestPending = "deploy_request_pending"
    case deployRequestAccepted = "deploy_request_accepted"
    case deployRequestRejected = "deploy_request_rejected"
    case submissionCreated = "submission_created"
}

enum HookActor: String, Codable {
    case deploy
    case formSubmission = "form_submission"
}

extension HookEvent {
    var actor: HookActor {
        switch self {
        case .deployCreated,
             .deployBuilding,
             .deployFailed,
             .deployRequestPending,
             .deployRequestAccepted,
             .deployRequestRejected:
            return .deploy
        case .submissionCreated:
            return .formSubmission
        }
    }
}
