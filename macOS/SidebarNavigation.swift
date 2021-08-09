//
//  SidebarNavigation.swift
//  SidebarNavigation
//
//  Created by Дмитрий Лисин on 09.08.2021.
//

import SwiftUI

struct SidebarNavigation: View {
    @State private var selection: NavigationItem? = .sites
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(tag: NavigationItem.sites, selection: $selection) {
                    SitesList()
                } label: {
                    Label("Sites", systemImage: "macwindow")
                }
                NavigationLink(tag: NavigationItem.builds, selection: $selection) {
                    BuildsList()
                } label: {
                    Label("Builds", systemImage: "square.stack.3d.up")
                }
                NavigationLink(tag: NavigationItem.news, selection: $selection) {
                    NewsView()
                } label: {
                    Label("News", systemImage: "newspaper")
                }
                NavigationLink(tag: NavigationItem.profile, selection: $selection) {
                    ProfileView()
                } label: {
                    Label("Profile", systemImage: "person")
                }
            }
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            
            Text("Select a category")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .ignoresSafeArea()
            
            Text("Details view")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .ignoresSafeArea()
            
            Text("Details view")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .ignoresSafeArea()
        }
    }
    
    enum NavigationItem {
        case sites
        case builds
        case news
        case profile
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
