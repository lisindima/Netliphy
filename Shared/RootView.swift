//
//  RootView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.03.2021.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    var body: some View {
        #if targetEnvironment(simulator)
        SitesView()
        #else
        if sessionStore.accessToken.isEmpty {
            LoginView()
        } else {
            SitesView()
        }
        #endif
    }
}
