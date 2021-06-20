//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI
import WidgetKit

@MainActor
class SessionStore: ObservableObject {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    @CodableUserDefaults(key: "user", defaultValue: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    func signOut() {
        accessToken = ""
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            user = nil
        }
    }
    
    func getCurrentUser() async {
        do {
            user = try await Loader.shared.fetch(.user)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("getCurrentUser", error)
        }
    }
}
