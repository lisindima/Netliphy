//
//  Provider.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 18.04.2021.
//

import SwiftUI
import WidgetKit

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
