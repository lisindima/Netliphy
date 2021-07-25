//
//  TestWidget.swift
//  TestWidget
//
//  Created by Дмитрий Лисин on 26.04.2021.
//

import Intents
import SwiftUI
import WidgetKit

@main
struct DeployWidget: Widget {
    let kind: String = "DeployWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: SelectSiteIntent.self,
            provider: Provider()
        ) { entry in
            DeployWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Status last deploy")
        .description("The widget shows the status of the latest deploy.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct DeployWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? #colorLiteral(red: 0.1205740815, green: 0.1305481929, blue: 0.1450380993, alpha: 1) : .white)
            switch widgetFamily {
            case .systemSmall:
                SmallWidget(entry: entry)
            case .systemLarge:
                LargeWidget(entry: entry)
            default:
                SmallWidget(entry: entry)
            }
        }
        .redacted(reason: entry.placeholder ? .placeholder : [])
    }
}

struct SiteEntry: TimelineEntry {
    let date: Date
    let configuration: SelectSiteIntent
    let deploys: [Deploy]
    let placeholder: Bool
}

struct DeployWidget_Previews: PreviewProvider {
    static var previews: some View {
        DeployWidgetEntryView(
            entry: SiteEntry(
                date: Date(),
                configuration: SelectSiteIntent(),
                deploys: .arrayPlaceholder,
                placeholder: false
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
