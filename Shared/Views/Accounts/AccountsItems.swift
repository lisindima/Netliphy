//
//  AccountsItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.06.2021.
//

import SwiftUI

struct AccountsItems: View {
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarUrl) { image in
                image
                    .resizable()
                    .mask(RoundedRectangle(cornerRadius: 10))
                
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(user.fullName ?? user.id)
                    .font(.headline)
                if let email = user.email {
                    Text(email)
                        .font(.footnote)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
