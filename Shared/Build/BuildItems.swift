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
        NavigationLink {
            DeployDetails(deployId: build.deployId)
        } label: {
            HStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(build.state.color)
                    .frame(width: 7)
                VStack(alignment: .leading) {
                    HStack {
                        Text(build.context.prettyValue)
                            .fixedSize()
                        if let reviewId = build.reviewId {
                            Text("#\(reviewId)")
                        }
                        Text(build.gitInfo)
                            .font(.footnote)
                    }
                    .font(.footnote.weight(.bold))
                    .lineLimit(1)
                    if let title = build.title {
                        Text(title)
                            .font(.footnote)
                            .lineLimit(2)
                    }
                    Group {
                        if let errorMessage = build.errorMessage {
                            Text(errorMessage)
                                .lineLimit(2)
                        }
                        if let deployTime = build.deployTime {
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
