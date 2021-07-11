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
        SiteEntry(date: Date(), configuration: SelectSiteIntent(), deploys: .arrayPlaceholder, placeholder: true)
    }

    func getSnapshot(for configuration: SelectSiteIntent, in context: Context, completion: @escaping (SiteEntry) -> Void) {
        if context.isPreview {
            completion(SiteEntry(date: Date(), configuration: configuration, deploys: .arrayPlaceholder, placeholder: false))
        } else {
            if let site = configuration.chosenSite {
                async {
                    do {
                        let value: [Deploy] = try await Loader.shared.fetch(.deploys(site.identifier ?? "", items: 5))
                        completion(SiteEntry(date: Date(), configuration: configuration, deploys: value, placeholder: false))
                    } catch {
                        completion(SiteEntry(date: Date(), configuration: configuration, deploys: .arrayPlaceholder, placeholder: true))
                        print(error)
                    }
                }
            } else {
                completion(SiteEntry(date: Date(), configuration: configuration, deploys: .arrayPlaceholder, placeholder: true))
            }
        }
    }

    func getTimeline(for configuration: SelectSiteIntent, in _: Context, completion: @escaping (Timeline<SiteEntry>) -> Void) {
        if let site = configuration.chosenSite {
            async {
                do {
                    let value: [Deploy] = try await Loader.shared.fetch(.deploys(site.identifier ?? "", items: 5))
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploys: value, placeholder: false)], policy: .after(Date().addingTimeInterval(600)))
                    completion(timeline)
                } catch {
                    let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploys: .arrayPlaceholder, placeholder: true)], policy: .after(Date().addingTimeInterval(300)))
                    completion(timeline)
                    print(error)
                }
            }
        } else {
            let timeline = Timeline(entries: [SiteEntry(date: Date(), configuration: configuration, deploys: .arrayPlaceholder, placeholder: true)], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
}
