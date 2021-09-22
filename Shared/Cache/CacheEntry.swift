//
//  CacheEntry.swift
//  Netliphy
//
//  Created by Дмитрий on 19.09.2021.
//

import Foundation

final class CacheEntry<V> {
    let key: String
    let value: V
    let expiredTimestamp: Date
    
    init(key: String, value: V, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }
    
    func isCacheExpired(after date: Date = .now) -> Bool {
        date > expiredTimestamp
    }
}

extension CacheEntry: Codable where V: Codable {}
