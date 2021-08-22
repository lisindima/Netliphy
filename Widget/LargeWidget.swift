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
            ForEach(entry.deploys) { deploy in
                Link(destination: URL(string: "netliphy://open?deployId=\(deploy.id)")!) {
                    DeployItems(deploy: deploy)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct DeployItems: View {
    let deploy: Deploy
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3)
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
                .font(.footnote.weight(.bold))
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
