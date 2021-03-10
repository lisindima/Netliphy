//
//  DeployItems.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

struct DeployItems: View {
    var deploy: Deploy
    
    @ViewBuilder
    var stateIcon: some View {
        switch deploy.state {
        case "error":
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        case "ready":
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        default:
            Image(systemName: "clock.arrow.2.circlepath")
                .foregroundColor(.yellow)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(deploy.context)
                    .fontWeight(.bold)
                Text(deploy.branch + "@" + deploy.commitRef.prefix(7))
            }
            .font(.footnote)
            .lineLimit(1)
            if let deployTime = deploy.deployTime {
                Text("Развернуто за: \(deployTime) секунд")
                    .font(.caption2)
            }
            if let errorMessage = deploy.errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .lineLimit(2)
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: Text("DD")) {
            Label(title: { title }, icon: { stateIcon })
        }
    }
}
