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
    @State private var deploySucceeded: Bool = false
    @State private var deployFailed: Bool = false
    @State private var loading: Bool = false
    
    let siteId: String
    
    var body: some View {
        Group {
            Toggle(isOn: $deploySucceeded) {
                Label("Deploy succeeded", systemImage: "timer")
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .onChange(of: deploySucceeded) { value in
                if value {
                    enableNotification(event: .deployCreated)
                }
            }
            Toggle(isOn: $deployFailed) {
                Label("Deploy failed", systemImage: "timer")
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .onChange(of: deployFailed) { value in
                if value {
                    enableNotification(event: .deployFailed)
                }
            }
        }
        .disabled(!loading)
        .onAppear(perform: loadingState)
    }
    
    private func loadingState() {
        Endpoint.api.fetch(.hooks(siteId: siteId)) { (result: Result<[Hook], ApiError>) in
            switch result {
            case let .success(value):
                value.forEach { site in
                    loading = true
                    if site.event == .deployCreated, site.type == "url" {
                        deploySucceeded = true
                    }
                    if site.event == .deployFailed, site.type == "url" {
                        deployFailed = true
                    }
                }
            case let .failure(error):
                print("getHooks", error)
            }
        }
    }
    
    private func enableNotification(event: Event) {
        let parameters = Hook(
            id: "609a634d03966addb90c9dca",
            siteId: siteId,
            formId: nil,
            formName: nil,
            userId: "",
            type: "url",
            event: event,
            data: [
                "url": "https://hooks.zapier.com/hooks/catch/"
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
                print(value)
            case let .failure(error):
                print("getHooks", error)
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
