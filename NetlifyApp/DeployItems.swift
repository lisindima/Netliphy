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
        if deploy.state == "error" {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        } else {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            if let reviewId = deploy.reviewId {
                Text("\(reviewId)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            Text(deploy.title)
                .font(.footnote)
                .lineLimit(1)
            Text(deploy.updatedAt, style: .relative)
                .font(.caption2)
        }
    }
    
    var body: some View {
        NavigationLink(destination: Text("DD")) {
            Label(title: { title }, icon: { stateIcon })
        }
    }
}
