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
    }
}
