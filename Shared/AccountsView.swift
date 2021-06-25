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
            Section(footer: Text(accounts.first?.token ?? "")) {
                ForEach(accounts, id: \.id) { account in
                    Text(account.token)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            Button {
                async {
                    await viewModel.signIn()
                }
            } label: {
                Label("Add account", systemImage: "person.badge.plus")
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            EditButton()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        accounts.remove(atOffsets: offsets)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        accounts.move(fromOffsets: source, toOffset: destination)
    }
}
