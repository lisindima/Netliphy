//
//  NotificationsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.05.2021.
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("notificationToken") private var notificationToken: String = ""
    @AppStorage("notificationsStatus") private var notificationsStatus: UNAuthorizationStatus = .notDetermined
    
    @State private var deploySucceeded: Bool = false
    @State private var deployFailed: Bool = false
    @State private var formNotifications: Bool = false
    @State private var loading: Bool = true
    @State private var succeededIdHook: String = ""
    @State private var failedIdHook: String = ""
    @State private var formIdHook: String = ""
    
    let siteId: String
    let forms: Forms?
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        Form {
            if notificationsStatus == .authorized {
                Section(header: Text("Deploy notification"), footer: Text("Select the deployment status that you want to track through notifications.")) {
                    Toggle(isOn: $deploySucceeded) {
                        DeployState.ready
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .onChange(of: deploySucceeded) { value in
                        if !loading {
                            if value {
                                createNotification(event: .deployCreated, actor: .deploy)
                            } else {
                                deleteNotification(id: succeededIdHook)
                            }
                        }
                    }
                    Toggle(isOn: $deployFailed) {
                        DeployState.error
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .onChange(of: deployFailed) { value in
                        if !loading {
                            if value {
                                createNotification(event: .deployFailed, actor: .deploy)
                            } else {
                                deleteNotification(id: failedIdHook)
                            }
                        }
                    }
                }
                .disabled(loading)
                if forms != nil {
                    Section(header: Text("Form notifications")) {
                        Toggle(isOn: $formNotifications) {
                            Label("New form submission", systemImage: "envelope.fill")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .onChange(of: formNotifications) { value in
                            print(value)
                        }
                    }
                }
            } else {
                Link("Включить уведомления", destination: URL(string: UIApplication.openSettingsURLString)!)
                    .onAppear(perform: enableNotification)
            }
        }
        .navigationTitle("Notifications")
        .onAppear(perform: loadingState)
    }
    
    private func loadingState() {
        Endpoint.api.fetch(.hooks(siteId: siteId)) { (result: Result<[Hook], ApiError>) in
            switch result {
            case let .success(value):
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
            case let .failure(error):
                print("getHooks", error)
            }
        }
    }
    
    private func createNotification(event: Event, actor: Actor) {
        let parameters = Hook(
            id: "",
            siteId: siteId,
            formId: nil,
            formName: nil,
            userId: "",
            type: "url",
            event: event,
            data: [
                "url": "https://lisindmitriy.me/.netlify/functions/notifications?device_id=\(notificationToken)",
            ],
            success: nil,
            createdAt: Date(),
            updatedAt: Date(),
            actor: actor,
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
}
