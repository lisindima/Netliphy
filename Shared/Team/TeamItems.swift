//
//  TeamItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import Kingfisher
import SwiftUI

struct TeamItems: View {
    let team: Team
    
    var body: some View {
        NavigationLink(destination: TeamDetails(team: team)) {
            HStack {
                KFImage(team.teamLogoUrl)
                    .resizable()
                    .placeholder {
                        Image("team")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .mask(RoundedRectangle(cornerRadius: 10))
                    }
                    .loadImmediately()
                    .frame(width: 50, height: 50)
                    .mask(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading) {
                    Text(team.name)
                        .font(.headline)
                    if let typeName = team.typeName {
                        Text(typeName)
                            .font(.footnote)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
}
