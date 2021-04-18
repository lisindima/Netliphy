//
//  SmallWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 18.04.2021.
//

import SwiftUI
import WidgetKit

struct SmallWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            entry.build.state
            Spacer()
            Group {
                Text(entry.build.subdomain)
                    .fontWeight(.bold)
                Text(entry.build.context.prettyValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text(entry.build.gitInfo)
                    .font(.caption2)
                if let deployTime = entry.build.deployTime {
                    Text(deployTime.convertedDeployTime(.short))
                        .font(.caption2)
                }
            }
            .lineLimit(1)
        }
        .padding(8)
    }
}
