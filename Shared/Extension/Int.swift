//
//  Int.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.04.2021.
//

import Foundation

extension Int {
    var byteSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = .useAll
        bcf.countStyle = .binary
        return bcf.string(fromByteCount: Int64(self))
    }
}
