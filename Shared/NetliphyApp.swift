//
//  NetliphyApp.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

@main
struct NetliphyApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var sessionStore = SessionStore()
    @AppStorage("notificationsEnabled") private var notificationsEnabled: UNAuthorizationStatus = .notDetermined
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionStore)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                UNUserNotificationCenter.current().getNotificationSettings { setting in
                    DispatchQueue.main.async { [self] in
                        notificationsEnabled = setting.authorizationStatus
                    }
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    @AppStorage("notificationToken") private var notificationToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UIApplication.shared.registerForRemoteNotifications()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let category = UNNotificationCategory(identifier: "deploy", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        notificationToken = token
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
