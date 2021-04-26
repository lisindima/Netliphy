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
    
    func provideChosenSiteOptionsCollection(for intent: SelectSiteIntent, with completion: @escaping (INObjectCollection<ChosenSite>?, Error?) -> Void) {
        
        var sites = [ChosenSite]()
        
        sites.append(ChosenSite(identifier: "293ac253-ed75-48c6-8cbb-c5488fbb720c", display: "lisindmitriy"))
        
        Endpoint.api.fetch(.sites) { (result: Result<[Site], ApiError>) in
            switch result {
            case let .success(value):
                for site in value {
                    sites.append(ChosenSite(identifier: site.id, display: site.name))
                    print(site)
                }
            case let .failure(error):
                print(error)
            }
        }
        
        let collection = INObjectCollection(items: sites)
        completion(collection, nil)
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
