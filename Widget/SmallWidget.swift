//
//  SmallWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 18.04.2021.
//

import SwiftUI
import WidgetKit

struct SmallWidget: View {
    let entry: Provider.Entry
    
    var deploy: Deploy {
        entry.deploys.first ?? .placeholder
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            deploy.state.widget
            Spacer()
            Group {
                Text(deploy.name)
                    .fontWeight(.bold)
                Text(deploy.context.prettyValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text(deploy.gitInfo)
                    .font(.caption2)
                HStack {
                    Text(deploy.createdAt, style: .relative) + Text(" ago")
                }
                .font(.caption2)
            }
            .lineLimit(1)
        }
        .padding(8)
        .widgetURL(URL(string: "netliphy://open?deployId=\(deploy.id)")!)
    }
}
