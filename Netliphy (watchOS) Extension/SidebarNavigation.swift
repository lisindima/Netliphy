//
//  SidebarNavigation.swift
//  Netliphy (watchOS) Extension
//
//  Created by Дмитрий Лисин on 01.08.2021.
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
            }
            .navigationTitle("Netliphy")
        }
    }
}

struct SidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavigation()
    }
}

