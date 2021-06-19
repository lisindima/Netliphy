//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Combine
import SwiftUI
import WidgetKit

@MainActor
class SessionStore: ObservableObject {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    @CodableUserDefaults(key: "user", defaultValue: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published private(set) var sitesLoadingState: LoadingState<[Site]> = .loading(Array(repeating: .placeholder, count: 3))
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func signOut() {
        accessToken = ""
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            user = nil
            sitesLoadingState = .loading(Array(repeating: .placeholder, count: 3))
        }
    }
    
    func getCurrentUser() async {
        do {
            user = try await Loader.shared.fetch(.user)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("getCurrentUser", error)
        }
    }
    
    func listSites() async {
        do {
            let value: [Site] = try await Loader.shared.fetch(.sites)
            if value.isEmpty {
                sitesLoadingState = .empty
            } else {
                sitesLoadingState = .success(value)
            }
        } catch {
            sitesLoadingState = .failure(error)
            print("listSites", error)
        }
    }
    
    func deleteNotification(_ id: String) async {
        do {
            try await Loader.shared.response(.hook(hookId: id), httpMethod: .delete)
        } catch {
            print(error)
        }
    }
    
    func enableNotification() {
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
