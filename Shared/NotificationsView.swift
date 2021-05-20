//
//  NotificationsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.05.2021.
//

import SwiftUI

struct NotificationsView: View {
    @AppStorage("notificationToken") private var notificationToken: String = ""
    
    @State private var deploySucceeded: Bool = false
    @State private var deployFailed: Bool = false
    @State private var loading: Bool = true
    @State private var succeededIdHook: String = ""
    @State private var failedIdHook: String = ""
    
    let siteId: String
    
    var body: some View {
        Form {
            Group {
                Toggle(isOn: $deploySucceeded) {
                    Label("Deploy ready", systemImage: "checkmark.circle.fill")
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
                    Label("Deploy error", systemImage: "xmark.circle.fill")
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
        .navigationTitle("Notifications")
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
                "url": "https://lisindmitriy.me/.netlify/functions/notifications?device_id=\(notificationToken)",
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
