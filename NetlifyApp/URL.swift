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
}
