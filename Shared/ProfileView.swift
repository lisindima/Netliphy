//
//  ProfileView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI
import StoreKit

struct ProfileView: View {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    var body: some View {
        List {
            if let account = accounts.first {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            AsyncImage(url: account.user.avatarUrl) { image in
                                image
                                    .resizable()
                                    .mask(Circle())
                                
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            if let fullName = account.user.fullName {
                                Text(fullName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            if let email = account.user.email {
                                Text(email)
                                    .font(.footnote)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                Section {
                    ForEach(account.teams, id: \.id, content: TeamItems.init)
                }
            }
            Section {
                NavigationLink {
                    DonateView()
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
            } footer: {
                appVersion
            }
        }
        .navigationTitle("Profile")
    }
    
    private var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("Version: \(version) (\(build))")
    }
}

struct DonateView: View {
    @StateObject private var viewModel = TipsStore()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.tips) { tip in
                    Button {
                        Task {
                            await purchase(tip)
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(tip.displayName)
                                    .foregroundColor(.primary)
                                    .fontWeight(.bold)
                                Text(tip.description)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(tip.displayPrice)
                                .fontWeight(.bold)
                        }
                    }
                }
            } footer: {
                Text("The tip jar helps keep Netliphy running, and helps with getting regular (and substantial) updates pushed out to you. If you enjoy using this app and want to support an independent app developer (that's me, Dmitriy), please consider sending a tip.")
            }
        }
        .navigationTitle("Tip Jar")
        .task {
            await viewModel.requestProducts()
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async {
        do {
            if try await viewModel.purchase(product) != nil {
                print("Yap")
            }
        } catch {
            print("Failed fuel purchase: \(error)")
        }
    }
}
