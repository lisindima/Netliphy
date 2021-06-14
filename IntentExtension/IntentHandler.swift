//
//  IntentHandler.swift
//  IntentExtension
//
//  Created by Дмитрий Лисин on 26.04.2021.
//

import Intents

class IntentHandler: INExtension, SelectSiteIntentHandling {
    func resolveChosenSite(for intent: SelectSiteIntent, with completion: @escaping (ChosenSiteResolutionResult) -> Void) {
        if let chosenSite = intent.chosenSite {
            completion(.success(with: chosenSite))
        }
    }
    
    func provideChosenSiteOptionsCollection(for _: SelectSiteIntent, with completion: @escaping (INObjectCollection<ChosenSite>?, Error?) -> Void) {
        var items = [ChosenSite]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        async {
            do {
                let value: [Site] = try await Loader.shared.fetch(.sites)
                value.forEach { site in
//                    items.append(ChosenSite(identifier: site.id, display: site.name))
                }
            } catch {
                print(error)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let collection = INObjectCollection(items: items)
            completion(collection, nil)
        }
    }
    
    override func handler(for _: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        self
    }
}
