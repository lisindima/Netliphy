//
//  IntentHandler.swift
//  IntentExtension
//
//  Created by Дмитрий Лисин on 26.04.2021.
//

import Intents

class IntentHandler: INExtension, SelectSiteIntentHandling {
    func resolveChosenSite(for intent: SelectSiteIntent) async -> ChosenSiteResolutionResult {
        .success(with: intent.chosenSite!)
    }
    
    func provideChosenSiteOptionsCollection(for _: SelectSiteIntent) async throws -> INObjectCollection<ChosenSite> {
        var items = [ChosenSite]()
        
        do {
            let value: [Site] = try await Loader.shared.fetch(for: .sites)
            value.forEach { site in
                items.append(ChosenSite(identifier: site.id, display: site.name))
            }
        } catch {
            print(error)
        }
        
        let collection = INObjectCollection(items: items)
        return collection
    }
    
    override func handler(for _: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        self
    }
}
