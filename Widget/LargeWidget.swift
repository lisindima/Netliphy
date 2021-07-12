//
//  LargeWidget.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.07.2021.
//

import SwiftUI
import WidgetKit

struct LargeWidget: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(entry.deploys.first?.name ?? "Site name")
                .fontWeight(.bold)
            Divider()
            ForEach(entry.deploys, id: \.id) { deploy in
                Link(destination: URL(string: "netliphy://open?deployId=\(deploy.id)")!) {
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
            }
            Spacer()
        }
        .padding()
    }
}
