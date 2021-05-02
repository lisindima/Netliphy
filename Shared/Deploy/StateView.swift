//
//  StateView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 30.04.2021.
//

import SwiftUI

struct StateView: View {
    let deploy: Deploy
    
    @ViewBuilder
    var details: some View {
        switch deploy.state {
        case .error:
            Label {
                Text("Error")
                    .fontWeight(.bold)
            } icon: {
                deploy.state
            }
            .foregroundColor(.red)
        case .ready:
            Label {
                Text("Ready")
                    .fontWeight(.bold)
            } icon: {
                deploy.state
            }
            .foregroundColor(.green)
        case .new:
            Label {
                Text("New")
                    .fontWeight(.bold)
            } icon: {
                deploy.state
            }
            .foregroundColor(.purple)
        case .building:
            Label {
                Text("Building")
                    .fontWeight(.bold)
            } icon: {
                deploy.state
            }
            .foregroundColor(.yellow)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                details
                Spacer()
                Group {
                    if let reviewId = deploy.reviewId {
                        Text(deploy.context.prettyValue) + Text(" #\(reviewId)")
                    } else {
                        Text(deploy.context.prettyValue)
                    }
                }
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
            }
        }
    }
}
