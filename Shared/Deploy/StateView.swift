//
//  StateView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 30.04.2021.
//

import SwiftUI

struct StateView: View {
    let state: DeployState
    let context: DeployContext
    let reviewId: Int?
    
    @ViewBuilder
    var details: some View {
        switch state {
        case .error:
            Label {
                Text("Error")
                    .fontWeight(.bold)
            } icon: {
                state
            }
            .foregroundColor(.red)
        case .ready:
            Label {
                Text("Ready")
                    .fontWeight(.bold)
            } icon: {
                state
            }
            .foregroundColor(.green)
        case .new:
            Label {
                Text("New")
                    .fontWeight(.bold)
            } icon: {
                state
            }
            .foregroundColor(.purple)
        case .building:
            Label {
                Text("Building")
                    .fontWeight(.bold)
            } icon: {
                state
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
                    if let reviewId = reviewId {
                        Text(context.prettyValue)
                            .fontWeight(.bold)
                        +
                        Text(" #\(reviewId)")
                            .fontWeight(.bold)
                    } else {
                        Text(context.prettyValue)
                            .fontWeight(.bold)
                    }
                }
                .foregroundColor(.secondary)
            }
        }
    }
}
