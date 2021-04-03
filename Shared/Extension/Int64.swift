//
//  Int64.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.04.2021.
//

import Foundation

extension Int64 {
    var byteSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = .useAll
        bcf.countStyle = .file
        return bcf.string(fromByteCount: self)
    }
}
