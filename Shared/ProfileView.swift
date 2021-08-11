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
        }
        .navigationTitle("Profile")
    }
}
