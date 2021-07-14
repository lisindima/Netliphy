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
            Label {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text(deploy.context.prettyValue)
                            if let reviewId = deploy.reviewId {
                                Text("#\(reviewId)")
                            }
                        }
                        .font(.footnote.weight(.bold))
                        Text(deploy.gitInfo)
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    Group {
                        if let errorMessage = deploy.errorMessage {
                            Text(errorMessage)
                                .lineLimit(2)
                        }
                        if let deployTime = deploy.deployTime {
                            Text("Deployed in \(deployTime.convertedDeployTime)")
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            } icon: {
                deploy.state
                    .labelStyle(.iconOnly)
            }
        }
        .contextMenu {
            Link(destination: deploy.deployUrl) {
                Label("Open deploy", systemImage: "safari.fill")
            }
            if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                Link(destination: commitUrl) {
                    Label("View commit \(String(commitRef.prefix(7)))", systemImage: "tray.full.fill")
                }
            }
        }
    }
}
