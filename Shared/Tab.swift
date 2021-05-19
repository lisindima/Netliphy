//
//  Tab.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct Tab: View {
    @State private var sheetItem: SheetItem?
    
    var body: some View {
        TabView {
            NavigationView {
                SitesList()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("navigation_title_sites", systemImage: "rectangle")
            }
            NavigationView {
                BuildsList()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("navigation_title_builds", systemImage: "square.stack.3d.up")
            }
            NavigationView {
                ProfileView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("navigation_title_profile", systemImage: "person")
            }
            NavigationView {
                SettingsView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
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
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gear")
            }
        }
        .navigationTitle("Netliphy")
        .listStyle(SidebarListStyle())
    }
}
