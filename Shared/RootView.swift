//
//  RootView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.03.2021.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if sessionStore.accessToken.isEmpty {
            LoginView()
        } else {
            navigationColums
        }
    }
    
    @ViewBuilder
    var navigationColums: some View {
        if horizontalSizeClass == .compact {
            Tab()
        } else {
            NavigationView {
                SitesList()
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
}

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
        .sheet(item: $sheetItem) { item in
            NavigationView {
                DeployDetails(deployId: item.id)
                    .navigationBarItems(trailing: navigationDeploy)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onOpenURL(perform: presentDeploy)
    }
    
    private var navigationDeploy: some View {
        Button(action: { sheetItem = nil }) {
            ExitButtonView()
        }
        .frame(width: 30, height: 30)
    }
    
    private func presentDeploy(_ url: URL) {
        guard let id = url["deployId"] else { return }
        sheetItem = SheetItem(id: id)
    }
}

struct SheetItem: Identifiable {
    let id: String
}
