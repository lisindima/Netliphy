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
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    @Published var userLoadingState: LoadingState<User> = .loading(.placeholder)
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published var teamsLoadingState: LoadingState<[Team]> = .loading(Array(repeating: .placeholder, count: 1))
    @Published var newsLoadingState: LoadingState<[News]> = .loading(Array(repeating: .placeholder, count: 8))
    @Published var buildsLoadingState: LoadingState<[Build]> = .loading(Array(repeating: .placeholder, count: 10))
    
    static let shared = SessionStore()
    
    func signIn(callbackURL: URL?, error: Error?) {
        if let error = error {
            print(error)
        }
        guard let url = callbackURL else { return }
        accessToken = url.accessToken
    }
    
    func signOut() {
        accessToken = ""
        userLoadingState = .loading(.placeholder)
        sitesLoadingState = .loading(Array(repeating: .placeholder, count: 3))
        newsLoadingState = .loading(Array(repeating: .placeholder, count: 8))
        teamsLoadingState = .loading(Array(repeating: .placeholder, count: 1))
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    func getCurrentUser() {
        Endpoint.api.fetch(.user) { [self] (result: Result<User, ApiError>) in
            switch result {
            case let .success(value):
                userLoadingState = .success(value)
                WidgetCenter.shared.reloadAllTimelines()
            case let .failure(error):
                userLoadingState = .failure(error)
                print("getCurrentUser", error)
            }
        }
    }
    
    func listSites() {
        Endpoint.api.fetch(.sites) { [self] (result: Result<[Site], ApiError>) in
            switch result {
            case let .success(value):
                if value.isEmpty {
                    sitesLoadingState = .empty
                } else {
                    sitesLoadingState = .success(value)
                }
            case let .failure(error):
                sitesLoadingState = .failure(error)
                print("listSites", error)
            }
        }
    }
    
    func listBuilds() {
        if case let .success(value) = userLoadingState {
            Endpoint.api.fetch(.builds(slug: value.slug ?? "")) { [self] (result: Result<[Build], ApiError>) in
                switch result {
                case let .success(value):
                    if value.isEmpty {
                        buildsLoadingState = .empty
                    } else {
                        buildsLoadingState = .success(value)
                    }
                case let .failure(error):
                    buildsLoadingState = .failure(error)
                    print("listBuilds", error)
                }
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
                print("listAccountsForUser", error)
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
                print("getNews", error)
            }
        }
    }
}
