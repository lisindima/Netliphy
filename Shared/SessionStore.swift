//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Combine
import SwiftUI
import WidgetKit

final class SessionStore: ObservableObject {
    @CodableUserDefaults(key: "user", suiteName: "group.darkfox.netliphy", defaultValue: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published var teamsLoadingState: LoadingState<[Team]> = .loading(Array(repeating: .placeholder, count: 1))
    @Published var newsLoadingState: LoadingState<[News]> = .loading(Array(repeating: .placeholder, count: 8))
    
    static let shared = SessionStore()
    
    func signIn(callbackURL: URL?, error: Error?) {
        if let error = error {
            print(error)
        }
        guard let url = callbackURL else { return }
        accessToken = url.accessToken
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func signOut() {
        accessToken = ""
        user = nil
        sitesLoadingState = .loading(Array(repeating: .placeholder, count: 3))
        newsLoadingState = .loading(Array(repeating: .placeholder, count: 8))
        teamsLoadingState = .loading(Array(repeating: .placeholder, count: 1))
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
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
