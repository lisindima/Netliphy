//
//  MemberItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.04.2021.
//

import SwiftUI
import Kingfisher

struct MemberItems: View {
    let member: Member
    
    var body: some View {
        HStack {
            KFImage(member.avatar)
                .resizable()
                .placeholder {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                .loadImmediately()
                .frame(width: 50, height: 50)
                .mask(RoundedRectangle(cornerRadius: 10))
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
