//
//  URL.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Foundation

extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.netlify.com/api/v1/\(endpoint)")!
    }
    
    var accessToken: String {
        var components = URLComponents()
        components.query = fragment
        
        let token = components.queryItems?.first
        guard let valueToken = token?.value else { return "" }
        
        let type = components.queryItems?.last
        guard let valueType = type?.value else { return "" }
        
        return valueType + " " + valueToken
    }
    
    subscript(queryParam: String) -> String {
        guard let url = URLComponents(string: absoluteString) else { return "" }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value ?? ""
    }
}
