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
                Label("Sites", systemImage: "rectangle")
            }
            NavigationView {
                BuildsList()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Builds", systemImage: "square.stack.3d.up")
            }
            NavigationView {
                ProfileView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

struct TabList: View {
    var body: some View {
        List {
            NavigationLink(destination: SitesList()) {
                Label("Sites", systemImage: "rectangle")
            }
            NavigationLink(destination: BuildsList()) {
                Label("Builds", systemImage: "square.stack.3d.up")
            }
        }
        .navigationTitle("Netliphy")
        .listStyle(SidebarListStyle())
    }
}
