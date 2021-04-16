//
//  NetliphyWidget.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 16.04.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), build: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if context.isPreview {
            completion(SimpleEntry(date: Date(), build: .placeholder))
        } else {
            Endpoint.api.fetch(.builds(slug: "lisindima")) { (result: Result<[Build], ApiError>) in
                switch result {
                case let .success(value):
                    print(value)
                    completion(SimpleEntry(date: Date(), build: value.first!))
                case let .failure(error):
                    completion(SimpleEntry(date: Date(), build: .placeholder))
                    print(error)
                }
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Endpoint.api.fetch(.builds(slug: "lisindima")) { (result: Result<[Build], ApiError>) in
            switch result {
            case let .success(value):
                print(value)
                let timeline = Timeline(entries: [SimpleEntry(date: Date(), build: value.first!)], policy: .after(Date().addingTimeInterval(60 * 10)))
                completion(timeline)
            case let .failure(error):
                let timeline = Timeline(entries: [SimpleEntry(date: Date(), build: .placeholder)], policy: .after(Date().addingTimeInterval(60 * 2)))
                completion(timeline)
                print(error)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let build: Build
}

struct Netliphy_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
        Text(entry.build.context)
    }
}

@main
struct NetliphyWidget: Widget {
    let kind: String = "NetliphyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Netliphy_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Last build")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct NetliphyWidget_Previews: PreviewProvider {
    static var previews: some View {
        Netliphy_WidgetEntryView(entry: SimpleEntry(date: Date(), build: .placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
