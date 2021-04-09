//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Combine
import SwiftUI

final class SessionStore: ObservableObject {
    @CodableUserDefaults(key: "user", default: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("accessToken") var accessToken: String = "" {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published var teamsLoadingState: LoadingState<[Team]> = .loading(Array(repeating: .placeholder, count: 1))
    @Published var newsLoadingState: LoadingState<[News]> = .loading(Array(repeating: .placeholder, count: 8))
    
    static let shared = SessionStore()
    
    func getCurrentUser() {
        Endpoint.api.fetch(.user) { [self] (result: Result<User, ApiError>) in
            switch result {
            case let .success(value):
                user = value
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func listSites() {
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
    
    func listAccountsForUser() {
        Endpoint.api.fetch(.accounts) { [self] (result: Result<[Team], ApiError>) in
            switch result {
            case let .success(value):
                teamsLoadingState = .success(value)
            case let .failure(error):
                teamsLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    func getNews() {
        Endpoint.api.fetch(.news) { [self] (result: Result<[News], ApiError>) in
            switch result {
            case let .success(value):
                newsLoadingState = .success(value)
            case let .failure(error):
                newsLoadingState = .failure(error)
                print(error)
            }
        }
    }
}
