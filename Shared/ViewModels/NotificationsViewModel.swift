//
//  NotificationsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.06.2021.
//

import SwiftUI

@MainActor
class NotificationsViewModel: ObservableObject {
    @AppStorage("notificationToken") private var notificationToken: String = ""
    
    @Published var deploySucceeded: Bool = false
    @Published var succeededIdHook: String = ""
    @Published var deployFailed: Bool = false
    @Published var failedIdHook: String = ""
    @Published var formNotifications: Bool = false
    @Published var formIdHook: String = ""
    @Published var loading: Bool = true
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func deleteNotification(_ id: String) async {
        do {
            try await Loader.shared.response(for: .hook(id), httpMethod: .delete)
        } catch {
            print(error)
        }
    }
    
    func enableNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Enabled notifications")
                UIApplication.shared.registerForRemoteNotifications()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadingState(_ siteId: String) async {
        do {
            let value: [Hook] = try await Loader.shared.fetch(for: .hooks(siteId))
            value.forEach { hook in
                if let data = hook.data["url"], let url = data {
                    if let url = URL(string: url), notificationToken == url["device_id"] {
                        if hook.event == .deployCreated, hook.type == "url" {
                            deploySucceeded = true
                            succeededIdHook = hook.id
                        } else if hook.event == .deployFailed, hook.type == "url" {
                            deployFailed = true
                            failedIdHook = hook.id
                        } else if hook.event == .submissionCreated, hook.type == "url" {
                            formNotifications = true
                            formIdHook = hook.id
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                loading = false
            }
        } catch {
            print("getHooks", error)
        }
    }
    
    func createNotification(event: HookEvent, siteId: String) async {
        do {
            let value: Hook = try await Loader.shared.upload(for: .hooks(siteId), parameters: parameters(event: event, siteId: siteId))
            if event == .deployCreated {
                succeededIdHook = value.id
            }
            if event == .deployFailed {
                failedIdHook = value.id
            }
            if event == .submissionCreated {
                formIdHook = value.id
            }
        } catch {
            print(error)
        }
    }
    
    private func parameters(
        event: HookEvent,
        siteId: String
    ) -> Hook {
        Hook(
            id: "",
            siteId: siteId,
            formId: nil,
            formName: nil,
            userId: "",
            type: "url",
            event: event,
            data: [
                "url": "https://lisindmitriy.me/.netlify/functions/\(event.actor.rawValue)?device_id=\(notificationToken)"
            ],
            success: nil,
            createdAt: Date(),
            updatedAt: Date(),
            actor: event.actor,
            disabled: false,
            restricted: false
        )
    }
}
