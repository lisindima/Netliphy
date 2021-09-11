//
//  SiteLoader.swift
//  SiteLoader
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import Foundation

struct SiteLoader: Codable {
    let deploys: [Deploy]
    let forms: [SiteForm]
    let functions: FunctionInfo?
}

extension SiteLoader {
    static let placeholder = SiteLoader(deploys: .arrayPlaceholder, forms: .arrayPlaceholder, functions: .placeholder)
}
