//
//  NotificationsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.05.2021.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    
    @AppStorage("notificationsStatus") private var notificationsStatus: UNAuthorizationStatus = .notDetermined
    
    let siteId: String
    let forms: Forms?
    
    var body: some View {
        Form {
            if notificationsStatus == .authorized {
                Group {
                    Section(header: Text("Deploy notifications"), footer: Text("Select the deployment status that you want to track through notifications.")) {
                        Toggle(isOn: $viewModel.deploySucceeded) {
                            DeployState.ready
                        }
                        .tint(.accentColor)
                        .onChange(of: viewModel.deploySucceeded) { value in
                            if !viewModel.loading {
                                async {
                                    if value {
                                        await viewModel.createNotification(event: .deployCreated, siteId: siteId)
                                    } else {
                                        await viewModel.deleteNotification(viewModel.succeededIdHook)
                                    }
                                }
                            }
                        }
                        Toggle(isOn: $viewModel.deployFailed) {
                            DeployState.error
                        }
                        .tint(.accentColor)
                        .onChange(of: viewModel.deployFailed) { value in
                            if !viewModel.loading {
                                async {
                                    if value {
                                        await viewModel.createNotification(event: .deployFailed, siteId: siteId)
                                    } else {
                                        await viewModel.deleteNotification(viewModel.failedIdHook)
                                    }
                                }
                            }
                        }
                    }
                    if forms != nil {
                        Section(header: Text("Form notifications")) {
                            Toggle(isOn: $viewModel.formNotifications) {
                                Label("New form submission", systemImage: "envelope.fill")
                            }
                            .tint(.accentColor)
                            .onChange(of: viewModel.formNotifications) { value in
                                if !viewModel.loading {
                                    async {
                                        if value {
                                            await viewModel.createNotification(event: .submissionCreated, siteId: siteId)
                                        } else {
                                            await viewModel.deleteNotification(viewModel.formIdHook)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .disabled(viewModel.loading)
                .redacted(reason: viewModel.loading ? .placeholder : [])
            } else {
                Link("Enable notifications", destination: URL(string: UIApplication.openSettingsURLString)!)
                    .onAppear {
                        async {
                            viewModel.enableNotification()
                        }
                    }
            }
        }
        .navigationTitle("Notifications")
        .task {
            await viewModel.loadingState(siteId)
        }
    }
}
