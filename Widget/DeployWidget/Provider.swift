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
        SiteEntry(date: Date(), configuration: SelectSiteIntent(), deploy: .placeholder, placeholder: true)
    }

    func getSnapshot(for configuration: SelectSiteIntent, in context: Context, completion: @escaping (SiteEntry) -> Void) {
        if context.isPreview {
            completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder, placeholder: false))
        } else {
            if !SessionStore.shared.accessToken.isEmpty, let site = configuration.chosenSite {
                Loader.shared.fetch(.deploys(siteId: site.identifier ?? "", items: 1)) { (result: Result<[Deploy], ApiError>) in
                    switch result {
                    case let .success(value):
                        completion(SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder, placeholder: false))
                    case let .failure(error):
                        completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder, placeholder: true))
                        print(error)
                    }
                }
            } else {
                completion(SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder, placeholder: true))
            }
        }
    }

    func getTimeline(for configuration: SelectSiteIntent, in _: Context, completion: @escaping (Timeline<SiteEntry>) -> Void) {
        if !SessionStore.shared.accessToken.isEmpty, let site = configuration.chosenSite {
            Loader.shared.fetch(.deploys(siteId: site.identifier ?? "", items: 1)) { (result: Result<[Deploy], ApiError>) in
                switch result {
                case let .success(value):
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder, placeholder: false)], policy: .after(Date().addingTimeInterval(600)))
                    completion(timeline)
                case let .failure(error):
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder, placeholder: true)], policy: .after(Date().addingTimeInterval(300)))
                    completion(timeline)
                    print(error)
                }
            }
        } else {
            let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: .placeholder, placeholder: true)], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
}
