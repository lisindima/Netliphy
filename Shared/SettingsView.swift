//
//  SettingsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.05.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("deploySucceeded") private var deploySucceeded: Bool = false
    @AppStorage("deployFailed") private var deployFailed: Bool = false
    
    var body: some View {
        Form {
            if !notificationsEnabled {
                Button("Включить уведомления", action: enableNotification)
            } else {
                Link("Выключить уведомления", destination: URL(string: UIApplication.openSettingsURLString)!)
            }
            if notificationsEnabled {
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Enabled notifications")
                notificationsEnabled = true
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func disableNotification() {
        notificationsEnabled = false
    }
}
