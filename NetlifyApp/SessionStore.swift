//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Combine
import SwiftUI

class SessionStore: ObservableObject {
    @CodableUserDefaults(key: "user", default: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading
    @AppStorage("accessToken") var accessToken: String = ""
    
    static let shared = SessionStore()
    
    func getCurrentUser() {
        print("getCurrentUser")
        
        Endpoint.api.fetch(.user) { [self] (result: Result<User, ApiError>) in
            switch result {
            case let .success(value):
                user = value
                print(value)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func listSites() {
        print("listSites")
        
        Endpoint.api.fetch(.sites()) { [self] (result: Result<[Site], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    sitesLoadingState = .empty
                } else {
                    sitesLoadingState = .success(value)
                }
            case let .failure(error):
                sitesLoadingState = .failure(error)
                print(error)
            }
        }
    }
}
