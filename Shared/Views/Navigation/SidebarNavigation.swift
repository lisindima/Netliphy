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
                NavigationLink {
                    SitesList()
                } label: {
                    Label("Sites", systemImage: "macwindow")
                }
                NavigationLink {
                    BuildsList()
                } label: {
                    Label("Builds", systemImage: "square.stack.3d.up")
                }
                NavigationLink {
                    NewsView()
                } label: {
                    Label("News", systemImage: "newspaper")
                }
                NavigationLink {
                    ProfileView()
                } label: {
                    Label("Profile", systemImage: "person")
                }
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Netliphy")
            
            Text("Select a category")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            Text("Details view")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
    }
}
