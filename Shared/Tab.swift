//
//  Tab.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct Tab: View {
    var body: some View {
        TabView {
            NavigationView {
                SitesList()
            }
            .tabItem {
                Label("navigation_title_sites", systemImage: "rectangle")
            }
            NavigationView {
                BuildsList()
            }
            .tabItem {
                Label("navigation_title_builds", systemImage: "square.stack.3d.up")
            }
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("navigation_title_profile", systemImage: "person")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TabList: View {
    var body: some View {
        List {
            NavigationLink(destination: SitesList()) {
                Label("navigation_title_sites", systemImage: "rectangle")
            }
            NavigationLink(destination: BuildsList()) {
                Label("navigation_title_builds", systemImage: "square.stack.3d.up")
            }
            NavigationLink(destination: ProfileView()) {
                Label("navigation_title_profile", systemImage: "person")
            }
        }
        .navigationTitle("Netliphy")
        .listStyle(.sidebar)
    }
}
