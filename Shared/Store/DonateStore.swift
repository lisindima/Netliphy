//
//  DonateStore.swift
//  DonateStore
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import SwiftUI
import StoreKit

@MainActor
class DonateStore: ObservableObject {
    @Published private(set) var donates: [Product] = []
    
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["com.darkfox.netliphy.donate.coffee"])

            var donates: [Product] = []

            for product in storeProducts {
                switch product.type {
                case .consumable:
                    donates.append(product)
                case .nonConsumable:
                    print(product)
                case .autoRenewable:
                    print(product)
                    
                default:
                    print("Unknown product")
                }
            }
            
            self.donates = sortByPrice(donates)
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }
}
