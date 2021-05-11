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
    @AppStorage("deploySucceeded") private var deploySucceeded: Bool = false
    @AppStorage("deployFailed") private var deployFailed: Bool = false
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        Form {
            if notificationsEnabled == .authorized {
                Button("Выключить уведомления", action: disableNotification)
            } else if notificationsEnabled == .notDetermined {
                Button("Включить уведомления", action: enableNotification)
            } else if notificationsEnabled == .denied {
                Link("Включить уведомления", destination: URL(string: UIApplication.openSettingsURLString)!)
            }
            if notificationsEnabled == .authorized {
                Section(header: Text("Deploy notifications")) {
                    Toggle(isOn: $deploySucceeded) {
                        Label("Deploy succeeded", systemImage: "timer")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Toggle(isOn: $deployFailed) {
                        Label("Deploy failed", systemImage: "timer")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
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
