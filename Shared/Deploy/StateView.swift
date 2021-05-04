//
//  StateView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 30.04.2021.
//

import SwiftUI

struct StateView: View {
    let deploy: Deploy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                deploy.state
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
