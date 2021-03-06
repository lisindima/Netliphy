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
    
    var body: some View {
        NavigationLink(destination: Text("DD")) {
            HStack {
                stateIcon
                VStack(alignment: .leading) {
                    Text(deploy.title)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text(deploy.updatedAt, style: .relative)
                        .font(.footnote)
                }
            }
        }
    }
}
