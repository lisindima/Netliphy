//
//  ChoiseNavigation.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.06.2021.
//

import SwiftUI

struct ChoiseNavigation: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(macOS)
        SidebarNavigation()
        #elseif os(iOS)
        if horizontalSizeClass == .compact {
            TabNavigation()
        } else {
            SidebarNavigation()
        }
        #else
        TabNavigation()
        #endif
    }
}
