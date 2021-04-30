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
        NavigationLink(destination: DeployDetails(deployId: deploy.id)) {
            Label {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text(deploy.context.prettyValue)
                                .fontWeight(.bold)
                            if let reviewId = deploy.reviewId {
                                Text("#\(reviewId)")
                                    .fontWeight(.bold)
                            }
                        }
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
                            Text("deploy_time_title \(deployTime.convertedDeployTime(.full))")
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            } icon: {
                deploy.state
            }
            .contextMenu {
                Link(destination: deploy.deployUrl) {
                    Label("button_open_deploy_url", systemImage: "safari.fill")
                }
                if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                    Link(destination: commitUrl) {
                        Label("View commit (\(String(commitRef.prefix(7))))", systemImage: "tray.full.fill")
                    }
                }
            }
        }
    }
}
