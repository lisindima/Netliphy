//
//  NetlifyAppApp.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

@main
struct NetlifyAppApp: App {
    @StateObject private var sessionStore = SessionStore.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionStore)
        }
    }
}
