//
//  BuildItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct BuildItems: View {
    let build: Build
    
    var body: some View {
        NavigationLink(destination: DeployDetails(deployId: build.deployId)) {
            Label {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text(build.context.prettyValue)
                            if let reviewId = build.reviewId {
                                Text("#\(reviewId)")
                            }
                        }
                        .font(.footnote.weight(.bold))
                        Text(build.gitInfo)
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    Group {
                        if let errorMessage = build.errorMessage {
                            Text(errorMessage)
                                .lineLimit(2)
                        }
                        if let deployTime = build.deployTime {
                            Text("Deployed in \(deployTime.convertedDeployTime)")
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            } icon: {
                build.state
                    .labelStyle(.iconOnly)
            }
            .contextMenu {
                if let alias = build.links.alias {
                    Link(destination: alias) {
                        Label("Open deploy", systemImage: "safari.fill")
                    }
                }
                if let commitUrl = build.commitUrl, let commitRef = build.commitRef {
                    Link(destination: commitUrl) {
                        Label("View commit \(String(commitRef.prefix(7)))", systemImage: "tray.full.fill")
                    }
                }
            }
        }
    }
}
