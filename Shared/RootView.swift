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
            NavigationView {
                SitesView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            NavigationView {
                SitesView()
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
