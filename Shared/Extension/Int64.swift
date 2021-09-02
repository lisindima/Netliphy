//
//  Int64.swift
//  Int64
//
//  Created by Дмитрий on 02.09.2021.
//

import Foundation

extension Int64 {
    var byteSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = .useAll
        bcf.countStyle = .binary
        return bcf.string(fromByteCount: self)
    }
}
