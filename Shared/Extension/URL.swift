//
//  URL.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Foundation

extension URL {
    static let authURL = URL(string: "https://app.netlify.com/authorize?response_type=token&client_id=g3HY3QeZegSC-qbJby-6wEXjJQBm1kDSWQuWTE52a1s&redirect_uri=https://cutt.ly/CzWICkG")!
    static let privacyPolicyURL = URL(string: "https://netliphy.lisindmitriy.me/privacypolicy")!
    static let termsURL = URL(string: "https://netliphy.lisindmitriy.me/terms")!
    static let reviewURL = URL(string: "https://apps.apple.com/us/app/netliphy/id1559050579?action=write-review")!
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.netlify.com/api/v1/\(endpoint)")!
    }
    
    var accessToken: String {
        var components = URLComponents()
        components.query = fragment
        
        let token = components.queryItems?.first
        guard let valueToken = token?.value else { return "" }
        
        return valueToken
    }
    
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
