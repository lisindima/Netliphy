//
//  TeamItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI
import Kingfisher

struct TeamItems: View {
    var team: Team
    
    var body: some View {
        NavigationLink(destination: TeamDetails(team: team)) {
            HStack {
                KFImage(team.teamLogoUrl)
                    .resizable()
                    .placeholder {
                        Image("team")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .mask(RoundedRectangle(cornerRadius: 10))
                    }
                    .loadImmediately()
                    .frame(width: 40, height: 40)
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
        }
    }
}
