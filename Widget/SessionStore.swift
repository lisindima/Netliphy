//
//  SessionStore.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 23.04.2021.
//

import SwiftUI

final class SessionStore: ObservableObject {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    static let shared = SessionStore()
}
