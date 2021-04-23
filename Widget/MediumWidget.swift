//
//  MediumWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 18.04.2021.
//

import SwiftUI
import WidgetKit

struct MediumWidget: View {
    let entry: Provider.Entry
    
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
                HStack {
                    Text(entry.build.createdAt, style: .relative) +
                    Text("site_items_ago")
                }
                .font(.caption2)
            }
            .lineLimit(1)
        }
        .padding(8)
    }
}
