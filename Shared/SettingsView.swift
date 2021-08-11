//
//  SettingsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.08.2021.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    TipsView()
                } label: {
                    Label("Tip Jar", systemImage: "heart.fill")
                        .accentColor(.pink)
                }
            }
            Section {
                NavigationLink {
                    AccountsView()
                } label: {
                    Label("Accounts", systemImage: "person.2")
                        #if !os(watchOS)
                        .badge(accounts.count)
                        #endif
                }
            }
            #if !os(watchOS)
            Section {
                NavigationLink {
                    FeedbackView()
                } label: {
                    Label("Submit Feedback", systemImage: "ladybug")
                }
                Link(destination: .reviewURL) {
                    Label("Review on App Store", systemImage: "star")
                }
            }
            Section {
                Link(destination: .privacyPolicyURL) {
                    Label("Privacy Policy", systemImage: "lock")
                }
                Link(destination: .privacyPolicyURL) {
                    Label("Terms of Use", systemImage: "book.closed")
                }
            } footer: {
                appVersion
            }
            #endif
        }
        .navigationTitle("Settings")
    }
    
    private var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("Version: \(version) (\(build))")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
