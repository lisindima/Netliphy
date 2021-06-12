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
