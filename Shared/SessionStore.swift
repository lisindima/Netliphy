//
//  SessionStore.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import AuthenticationServices
import Combine
import SwiftUI
import WidgetKit

final class SessionStore: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    @CodableUserDefaults(key: "user", defaultValue: nil) var user: User? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var sitesLoadingState: LoadingState<[Site]> = .loading(Array(repeating: .placeholder, count: 3))
    @Published var teamsLoadingState: LoadingState<[Team]> = .loading(Array(repeating: .placeholder, count: 1))
    @Published var newsLoadingState: LoadingState<[News]> = .loading(Array(repeating: .placeholder, count: 8))
    @Published var buildsLoadingState: LoadingState<[Build]> = .loading(Array(repeating: .placeholder, count: 10))
    
    static let shared = SessionStore()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private var subscriptions: [AnyCancellable] = []
    
    func signIn() {
        let signInPromise = Future<URL, Error> { completion in
            let authSession = ASWebAuthenticationSession(url: .authURL, callbackURLScheme: .callbackURLScheme) { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = false
            authSession.start()
        }
        
        signInPromise.sink { completion in
            switch completion {
            case let .failure(error):
                print("auth failed for reason: \(error)")
            default: break
            }
        } receiveValue: { [self] url in
            accessToken = url.accessToken
        }
        .store(in: &subscriptions)
    }
    
    func signOut() {
        accessToken = ""
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            user = nil
            sitesLoadingState = .loading(Array(repeating: .placeholder, count: 3))
            newsLoadingState = .loading(Array(repeating: .placeholder, count: 8))
            teamsLoadingState = .loading(Array(repeating: .placeholder, count: 1))
        }
    }
    
    func getCurrentUser() {
        Endpoint.api.fetch(.user) { [self] (result: Result<User, ApiError>) in
            switch result {
            case let .success(value):
                user = value
                WidgetCenter.shared.reloadAllTimelines()
            case let .failure(error):
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
        Endpoint.api.fetch(.builds(slug: user?.slug ?? "")) { [self] (result: Result<[Build], ApiError>) in
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
    
    func deleteNotification(id: String) {
        Endpoint.api.fetch(.hook(hookId: id), httpMethod: .delete) { (result: Result<Hook, ApiError>) in
            switch result {
            case .success, .failure:
                print("deleteNotification")
            }
        }
    }
    
    func enableNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Enabled notifications")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
