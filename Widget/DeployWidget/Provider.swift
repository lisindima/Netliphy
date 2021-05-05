//
//  Provider.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 26.04.2021.
//

import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in _: Context) -> SiteEntry {
        SiteEntry(date: Date(), configuration: SelectSiteIntent(), deploy: .placeholder)
    }

    func getSnapshot(for configuration: SelectSiteIntent, in context: Context, completion: @escaping (SiteEntry) -> Void) {
        if context.isPreview {
            completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder))
        } else {
            if !SessionStore.shared.accessToken.isEmpty, let site = configuration.chosenSite {
                Endpoint.api.fetch(.deploys(siteId: site.identifier ?? "", items: 1)) { (result: Result<[Deploy], ApiError>) in
                    switch result {
                    case let .success(value):
                        completion(SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder))
                    case let .failure(error):
                        completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder))
                        print(error)
                    }
                }
            } else {
                completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder))
            }
        }
    }

    func getTimeline(for configuration: SelectSiteIntent, in _: Context, completion: @escaping (Timeline<SiteEntry>) -> Void) {
        if !SessionStore.shared.accessToken.isEmpty, let site = configuration.chosenSite {
            Endpoint.api.fetch(.deploys(siteId: site.identifier ?? "", items: 1)) { (result: Result<[Deploy], ApiError>) in
                switch result {
                case let .success(value):
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder)], policy: .after(Date().addingTimeInterval(60 * 10)))
                    completion(timeline)
                case let .failure(error):
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder)], policy: .after(Date().addingTimeInterval(60 * 2)))
                    completion(timeline)
                    print(error)
                }
            }
        } else {
            let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder)], policy: .after(Date().addingTimeInterval(60 * 2)))
            completion(timeline)
        }
    }
}
