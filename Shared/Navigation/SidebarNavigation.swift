//
//  SidebarNavigation.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import SwiftUI

struct SidebarNavigation: View {
    var body: some View {
        NavigationView {
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
            
            Text("select_site_title")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text("details_view_title")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
}
