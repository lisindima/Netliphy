//
//  NetliphyWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 16.04.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BuildEntry {
        BuildEntry(date: Date(), build: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (BuildEntry) -> ()) {
        if context.isPreview {
            completion(BuildEntry(date: Date(), build: .placeholder))
        } else {
            Endpoint.api.fetch(.builds(slug: "lisindima")) { (result: Result<[Build], ApiError>) in
                switch result {
                case let .success(value):
                    completion(BuildEntry(date: Date(), build: value.first!))
                case let .failure(error):
                    completion(BuildEntry(date: Date(), build: .placeholder))
                    print(error)
                }
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BuildEntry>) -> ()) {
        Endpoint.api.fetch(.builds(slug: "lisindima")) { (result: Result<[Build], ApiError>) in
            switch result {
            case let .success(value):
                let timeline = Timeline(entries: [BuildEntry(date: Date(), build: value.first!)], policy: .after(Date().addingTimeInterval(60 * 10)))
                completion(timeline)
            case let .failure(error):
                let timeline = Timeline(entries: [BuildEntry(date: Date(), build: .placeholder)], policy: .after(Date().addingTimeInterval(60 * 2)))
                completion(timeline)
                print(error)
            }
        }
    }
}

struct BuildEntry: TimelineEntry {
    let date: Date
    let build: Build
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
            case .systemMedium:
                MediumWidget(entry: entry)
            default:
                SmallWidget(entry: entry)
            }
        }
    }
}

struct NetliphyWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NetliphyWidgetEntryView(entry: BuildEntry(date: Date(), build: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .colorScheme(.dark)
            NetliphyWidgetEntryView(entry: BuildEntry(date: Date(), build: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .colorScheme(.light)
        }
    }
}


@main
struct NetliphyWidget: Widget {
    let kind: String = "NetliphyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NetliphyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("configuration_display_name")
        .description("description")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
