//
//  NetliphyWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 16.04.2021.
//

import WidgetKit
import SwiftUI

@main
struct NetliphyWidget: Widget {
    let kind: String = "NetliphyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NetliphyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("configuration_display_name")
        .description("description")
        .supportedFamilies([.systemSmall])
    }
}

struct NetliphyWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? #colorLiteral(red: 0.1205740815, green: 0.1305481929, blue: 0.1450380993, alpha: 1) : .white)
            switch widgetFamily {
            case .systemSmall:
                SmallWidget(entry: entry)
            default:
                SmallWidget(entry: entry)
            }
        }
        .widgetURL(URL(string: "netliphy://widget?deployId=\(entry.build.deployId)")!)
    }
}

struct NetliphyWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NetliphyWidgetEntryView(entry: BuildEntry(date: Date(), build: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .colorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
            NetliphyWidgetEntryView(entry: BuildEntry(date: Date(), build: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .colorScheme(.dark)
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
