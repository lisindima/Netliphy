//
//  EventDeployItems.swift
//  EventDeployItems
//
//  Created by Дмитрий on 11.09.2021.
//

import SwiftUI

struct EventDeployItems: View {
    let event: EventDeploy
    
    var body: some View {
        NavigationLink(destination: EventDeployDetails(event: event)) {
            HStack(alignment: .top) {
                AsyncImage(url: event.user.avatar) { image in
                    image
                        .resizable()
                        .mask(Circle())
                    
                } placeholder: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .foregroundColor(.accentColor)
                }
                .frame(width: 24, height: 24)
                VStack(alignment: .leading) {
                    Text(event.user.name)
                        .font(.footnote.weight(.bold))
                    Text(event.info)
                        .font(.footnote)
                    Text(event.metadata.path)
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
        }
    }
}
