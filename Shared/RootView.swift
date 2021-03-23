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
    
    @ViewBuilder
    var twoColums: some View {
        if horizontalSizeClass == .compact {
            NavigationView {
                SitesView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            NavigationView {
                SitesView()
                Text("two_colums_title")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        #if targetEnvironment(simulator)
        twoColums
        #else
        if sessionStore.accessToken.isEmpty {
            LoginView()
        } else {
            twoColums
        }
        #endif
    }
}
