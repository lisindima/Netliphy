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
                async {
                    do {
                        let value: [Deploy] = try await Loader.shared.fetch(.deploys(site.identifier ?? "", items: 1))
                        completion(SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder, placeholder: false))
                    } catch {
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
            async {
                do {
                    let value: [Deploy] = try await Loader.shared.fetch(.deploys(site.identifier ?? "", items: 1))
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploy: value.first ?? .placeholder, placeholder: false)], policy: .after(Date().addingTimeInterval(600)))
                    completion(timeline)
                } catch {
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
