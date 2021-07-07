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
    
    var body: some View {
        VStack(alignment: .leading) {
            entry.deploy.state.widget
            Spacer()
            Group {
                Text(entry.deploy.name)
                    .fontWeight(.bold)
                Text(entry.deploy.context.prettyValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                Text(entry.deploy.gitInfo)
                    .font(.caption2)
                HStack {
                    Text(entry.deploy.createdAt, style: .relative) + Text(" ago")
                }
                .font(.caption2)
            }
            .lineLimit(1)
        }
        .padding(8)
    }
}
