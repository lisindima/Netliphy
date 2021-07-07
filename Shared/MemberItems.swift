//
//  MemberItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.04.2021.
//

import SwiftUI

struct MemberItems: View {
    let member: Member
    
    var body: some View {
        HStack {
            AsyncImage(url: member.avatar) { image in
                image
                    .resizable()
                    .mask(RoundedRectangle(cornerRadius: 10))
                
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(member.fullName)
                    .font(.headline)
                Text(member.email)
                    .font(.footnote)
                Text(member.role)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
