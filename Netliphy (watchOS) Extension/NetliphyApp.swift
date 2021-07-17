//
//  NetliphyApp.swift
//  Netliphy (watchOS) Extension
//
//  Created by Дмитрий Лисин on 16.07.2021.
//

import SwiftUI

@main
struct NetliphyApp: App {
    @StateObject private var sites = SitesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(sites)
            }
        }
    }
}
