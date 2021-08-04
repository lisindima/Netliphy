//
//  TabNavigation.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct TabNavigation: View {
    var body: some View {
        TabView {
            NavigationView {
                SitesList()
            }
            .tabItem {
                Label("Sites", systemImage: "macwindow")
            }
            NavigationView {
                BuildsList()
            }
            .tabItem {
                Label("Builds", systemImage: "square.stack.3d.up")
            }
            NavigationView {
                NewsView()
            }
            .tabItem {
                Label("News", systemImage: "newspaper")
            }
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            NavigationView {
                Text("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .navigationViewStyle(.stack)
    }
}
