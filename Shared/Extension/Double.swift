//
//  Double.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 02.04.2021.
//

import Foundation

extension Double {
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
            return Int64().byteSize
        }
    }
}
