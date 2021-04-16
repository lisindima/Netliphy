//
//  NetliphyApp.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

@main
struct NetliphyApp: App {
    @StateObject private var sessionStore = SessionStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionStore)
        }
    }
}
