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
            HStack {
                AsyncImage(url: event.user.avatar) { image in
                    image
                        .resizable()
                        .mask(Circle())
                    
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.accentColor)
                        Image(systemName: "person.fill.questionmark")
                            .foregroundColor(.black)
                    }
                    .mask(Circle())
                }
                .frame(width: 30, height: 30)
                VStack(alignment: .leading) {
                    Text(event.user.name)
                        .font(.footnote.weight(.bold))
                    Text(event.info)
                        .font(.footnote)
                }
            }
        }
    }
}
