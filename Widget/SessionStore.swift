//
//  SessionStore.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 23.04.2021.
//

import SwiftUI

final class SessionStore: ObservableObject {
    @CodableUserDefaults(key: "user", suiteName: "group.darkfox.netliphy", defaultValue: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    static let shared = SessionStore()
}
