//
//  ProfileView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

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
                if let connectedAccounts = account.user.connectedAccounts {
                    Section {
                        ForEach(connectedAccounts.keys.sorted(), id: \.self) { key in
                            if let value = connectedAccounts[key] {
                                FormItems(LocalizedStringKey(key), value: value)
                            }
                        }
                    }
                }
                Section {
                    ForEach(account.teams, content: TeamItems.init)
                }
            }
        }
        .navigationTitle("Profile")
    }
}
