//
//  DeployItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct DeployItems: View {
    let deploy: Deploy
    
    var body: some View {
        NavigationLink {
            DeployDetails(deployId: deploy.id)
        } label: {
            HStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(deploy.state.color)
                    .frame(width: 7)
                VStack(alignment: .leading) {
                    HStack {
                        Text(deploy.context.prettyValue)
                            .fixedSize()
                        if let reviewId = deploy.reviewId {
                            Text("#\(reviewId)")
                        }
                        Text(deploy.gitInfo)
                            .font(.footnote)
                    }
                    .font(.body.weight(.bold))
                    .lineLimit(1)
                    if let title = deploy.title {
                        Text(title)
                            .font(.footnote)
                            .lineLimit(2)
                    }
                    Group {
                        if let errorMessage = deploy.errorMessage {
                            Text(errorMessage)
                                .lineLimit(2)
                        }
                        if let deployTime = deploy.deployTime {
                            Text("Deployed in \(deployTime.convertToFullTime)")
                        }
                    }
                    .foregroundColor(.secondary)
                    .font(.caption2)
                }
            }
        }
    }
}

struct DeployItems_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeployItems(deploy: .placeholder)
        }
    }
}
