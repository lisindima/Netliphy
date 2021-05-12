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
    @State private var loadingDeploySucceeded: Bool = false
    @State private var loadingDeployFailed: Bool = false
    
    let siteId: String
    
    var body: some View {
        Group {
            Toggle(isOn: $deploySucceeded) {
                Label("Deploy succeeded", systemImage: "timer")
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .redacted(reason: loadingDeploySucceeded ? [] : .placeholder)
            .onChange(of: deploySucceeded) { value in
                print(value)
            }
            Toggle(isOn: $deployFailed) {
                Label("Deploy failed", systemImage: "timer")
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .redacted(reason: loadingDeployFailed ? [] : .placeholder)
            .onChange(of: deployFailed) { value in
                print(value)
            }
        }
        .disabled(!loadingDeploySucceeded)
        .onAppear(perform: loadingState)
    }
    
    private func loadingState() {
        Endpoint.api.fetch(.hooks(siteId: siteId)) { (result: Result<[Hook], ApiError>) in
            switch result {
            case let .success(value):
                value.forEach { site in
                    loadingDeploySucceeded = true
                    loadingDeployFailed = true
                    if site.event == "deploy_created", site.type == "url" {
                        deploySucceeded = true
                    }
                    if site.event == "deploy_failed", site.type == "url" {
                        deployFailed = true
                    }
                }
            case let .failure(error):
                print("getHooks", error)
            }
        }
    }
}
