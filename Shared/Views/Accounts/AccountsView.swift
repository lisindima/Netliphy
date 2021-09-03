//
//  AccountsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 24.06.2021.
//

import SwiftUI

struct AccountsView: View {
    @StateObject private var viewModel = AccountsViewModel()
    
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    @AppStorage("selectedSlug", store: store) private var selectedSlug: String = ""
    
    var body: some View {
        List {
            Section {
                ForEach(accounts) { account in
                    AccountsItems(user: account.user)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.delete(account)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            if let index = accounts.firstIndex(where: { $0.id == account.id }), index != 0 {
                                Button {
                                    withAnimation {
                                        viewModel.select(account)
                                    }
                                } label: {
                                    Label("Select", systemImage: "checkmark.circle")
                                }
                                .tint(.purple)
                            }
                        }
                }
            } footer: {
                Text("To select your account, swipe it on the left and click on the button.")
            }
            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                Label("Add account", systemImage: "person.badge.plus")
            }
        }
        .navigationTitle("Accounts")
        .onChange(of: accounts) { newValue in 
            if let teamName = newValue.first?.teams.first?.slug {
                selectedSlug = teamName
            }
        }
    }
}
