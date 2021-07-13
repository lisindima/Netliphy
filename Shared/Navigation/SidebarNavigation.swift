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
                    Label("Sites", systemImage: "rectangle")
                }
                NavigationLink(destination: BuildsList()) {
                    Label("Builds", systemImage: "square.stack.3d.up")
                }
                NavigationLink(destination: NewsView()) {
                    Label("News", systemImage: "newspaper")
                }
                NavigationLink(destination: ProfileView()) {
                    Label("Profile", systemImage: "person")
                }
            }
            .navigationTitle("Netliphy")
            #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            #endif
            
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
        }
    }
    
    #if os(macOS)
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}
