//
//  Double.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.04.2021.
//

import Foundation

extension Double {
    var byteSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = .useAll
        bcf.countStyle = .binary
        return bcf.string(fromByteCount: Int64(self))
    }
    
    func getUnit(unit: UsageUnit) -> String {
        switch unit {
        case .users:
            return "\(Int(self))"
        case .requests:
            return "\(Int(self))"
        case .seconds:
            return TimeInterval(self).convertToFullTime
        case .submissions:
            return "\(Int(self))"
        case .bytes:
            return byteSize
        }
    }
}
