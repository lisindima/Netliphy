//
//  SettingsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.05.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled: UNAuthorizationStatus = .notDetermined
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        Form {
            Section {
                if notificationsEnabled == .authorized {
                    Button("Выключить уведомления", action: disableNotification)
                } else if notificationsEnabled == .notDetermined {
                    Button("Включить уведомления", action: enableNotification)
                } else if notificationsEnabled == .denied {
                    Link("Включить уведомления", destination: URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            if notificationsEnabled == .authorized, case let .success(value) = sessionStore.sitesLoadingState {
                Section {
                    ForEach(value, id: \.id) { site in
                        DisclosureGroup(site.name) {
                            NotificationToggle(siteId: site.id)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
    
    private func enableNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Enabled notifications")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func disableNotification() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
        DispatchQueue.main.async {
            notificationCenter.removeAllPendingNotificationRequests()
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
}

struct NotificationToggle: View {
    @AppStorage("notificationToken") private var notificationToken: String = ""
    
    @State private var deploySucceeded: Bool = false
    @State private var deployFailed: Bool = false
    @State private var loading: Bool = true
    @State private var succeededIdHook: String = ""
    @State private var failedIdHook: String = ""
    
    let siteId: String
    
    var body: some View {
        Group {
            Toggle(isOn: $deploySucceeded) {
                Label("Successful deploys", systemImage: "checkmark.circle.fill")
                    .font(.body.weight(.bold))
                    .foregroundColor(.green)
            }
            .onChange(of: deploySucceeded) { value in
                if !loading {
                    if value {
                        createNotification(event: .deployCreated)
                    } else {
                        deleteNotification(id: succeededIdHook)
                    }
                }
            }
            Toggle(isOn: $deployFailed) {
                Label("Failed deploys", systemImage: "xmark.circle.fill")
                    .font(.body.weight(.bold))
                    .foregroundColor(.red)
            }
            .onChange(of: deployFailed) { value in
                if !loading {
                    if value {
                        createNotification(event: .deployFailed)
                    } else {
                        deleteNotification(id: failedIdHook)
                    }
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .disabled(loading)
        .onAppear(perform: loadingState)
    }
    
    private func loadingState() {
        Endpoint.api.fetch(.hooks(siteId: siteId)) { (result: Result<[Hook], ApiError>) in
            switch result {
            case let .success(value):
                value.forEach { hook in
                    if hook.event == .deployCreated, hook.type == "url" {
                        if let data = hook.data["url"], let url = data {
                            if let url = URL(string: url), notificationToken == url["device_id"] {
                                deploySucceeded = true
                                succeededIdHook = hook.id
                            }
                        }
                    }
                    if hook.event == .deployFailed, hook.type == "url" {
                        if let data = hook.data["url"], let url = data {
                            if let url = URL(string: url), notificationToken == url["device_id"] {
                                deployFailed = true
                                failedIdHook = hook.id
                            }
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    loading = false
                }
            case let .failure(error):
                print("getHooks", error)
            }
        }
    }
    
    private func createNotification(event: Event) {
        let parameters = Hook(
            id: "",
            siteId: siteId,
            formId: nil,
            formName: nil,
            userId: "",
            type: "url",
            event: event,
            data: [
                "url": "https://lisindmitriy.me/.netlify/functions/notifications?device_id=\(notificationToken)"
            ],
            success: nil,
            createdAt: Date(),
            updatedAt: Date(),
            actor: "deploy",
            disabled: false,
            restricted: false
        )
        
        Endpoint.api.upload(.hooks(siteId: siteId), parameters: parameters) { (result: Result<Hook, ApiError>) in
            switch result {
            case let .success(value):
                if event == .deployCreated {
                    succeededIdHook = value.id
                }
                if event == .deployFailed {
                    failedIdHook = value.id
                }
                print(value)
            case let .failure(error):
                if event == .deployCreated {
                    deploySucceeded = false
                }
                if event == .deployFailed {
                    deployFailed = false
                }
                print(error)
            }
        }
    }
    
    private func deleteNotification(id: String) {
        Endpoint.api.fetch(.hook(hookId: id), httpMethod: .delete) { (result: Result<Hook, ApiError>) in
            switch result {
            case .success, .failure:
                print("deleteNotification")
            }
        }
    }
}

enum Event: String, Codable {
    case deployCreated = "deploy_created"
    case deployBuilding = "deploy_building"
    case deployFailed = "deploy_failed"
    case deployRequestPending = "deploy_request_pending"
    case deployRequestAccepted = "deploy_request_accepted"
    case deployRequestRejected = "deploy_request_rejected"
}
