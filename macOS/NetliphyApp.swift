//
//  NetliphyApp.swift
//  Netliphy (macOS)
//
//  Created by Дмитрий Лисин on 12.07.2021.
//

import SwiftUI

@main
struct NetliphyApp: App {
    @StateObject private var sites = SitesViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sites)
        }
    }
}
