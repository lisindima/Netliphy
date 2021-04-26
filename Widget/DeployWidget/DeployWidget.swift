//
//  TestWidget.swift
//  TestWidget
//
//  Created by Дмитрий Лисин on 26.04.2021.
//

import WidgetKit
import SwiftUI
import Intents

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
        .configurationDisplayName("configuration_display_name")
        .description("description")
        .supportedFamilies([.systemSmall])
    }
}

struct DeployWidgetEntryView : View {
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? #colorLiteral(red: 0.1205740815, green: 0.1305481929, blue: 0.1450380993, alpha: 1) : .white)
            if !SessionStore.shared.accessToken.isEmpty, entry.configuration.chosenSite != nil {
                switch widgetFamily {
                case .systemSmall:
                    SmallWidget(entry: entry)
                default:
                    SmallWidget(entry: entry)
                }
            } else if SessionStore.shared.accessToken.isEmpty {
                WidgetMessage(
                    title: "title_no_account",
                    description: "description_no_account"
                )
            } else if entry.configuration.chosenSite == nil {
                WidgetMessage(
                    title: "title_site_not_selected",
                    description: "description_site_not_selected"
                )
            }
        }
        .widgetURL(URL(string: "netliphy://widget?deployId=\(entry.deploy.id)")!)
    }
}

struct SiteEntry: TimelineEntry {
    let date: Date
    let configuration: SelectSiteIntent
    let deploy: Deploy
}
