//
//  URL.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Foundation

extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "https://api.netlify.com/api/v1/\(endpoint)")!
    }
    
    func getAccessToken() -> String {
        var components = URLComponents()
        components.query = self.fragment
        
        let token = components.queryItems?.first
        guard let valueToken = token?.value else { return "" }
        
        let type = components.queryItems?.last
        guard let valueType = type?.value else { return "" }
        
        return valueType + " " + valueToken
    }
}
