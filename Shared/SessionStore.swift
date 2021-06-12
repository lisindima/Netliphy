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

@MainActor
final class SessionStore: NSObject, ObservableObject {
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
    
    func getCurrentUser() async {
        do {
            user = try await Loader.shared.fetch(.user)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("getCurrentUser", error)
        }
    }
    
    func listSites() async {
        do {
            let value: [Site] = try await Loader.shared.fetch(.sites)
            if value.isEmpty {
                sitesLoadingState = .empty
            } else {
                sitesLoadingState = .success(value)
            }
        } catch {
            sitesLoadingState = .failure(error)
            print("listSites", error)
        }
    }
    
    func listBuilds() async {
        do {
            let value: [Build] = try await Loader.shared.fetch(.builds(slug: user?.slug ?? ""))
            if value.isEmpty {
                buildsLoadingState = .empty
            } else {
                buildsLoadingState = .success(value)
            }
        } catch {
            buildsLoadingState = .failure(error)
            print("listBuilds", error)
        }
    }
    
    func listAccountsForUser() async {
        do {
            let value: [Team] = try await Loader.shared.fetch(.accounts)
            teamsLoadingState = .success(value)
        } catch {
            teamsLoadingState = .failure(error)
            print("listAccountsForUser", error)
        }
    }
    
    func getNews() async {
        do {
            let value: [News] = try await Loader.shared.fetch(.news)
            newsLoadingState = .success(value)

        } catch {
            newsLoadingState = .failure(error)
            print("getNews", error)
        }
    }
    
    func deleteNotification(_ id: String) async {
        do {
            _ = try await Loader.shared.response(.hook(hookId: id), httpMethod: .delete)
        } catch {
            print(error)
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
}

extension SessionStore: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
