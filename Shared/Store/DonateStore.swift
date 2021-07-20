//
//  DonateStore.swift
//  DonateStore
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import SwiftUI
import StoreKit

typealias Transaction = StoreKit.Transaction

@MainActor
class DonateStore: ObservableObject {
    @Published private(set) var donates: [Product] = []
    
    var task: Task<Void, Error>? = nil
    
    init() {
        task = listenForTransactions()
    }
    
    deinit {
        task?.cancel()
    }
    
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["com.darkfox.netliphy.donate.coffee", "com.darkfox.netliphy.donate.pizza"])

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
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }
    
    enum StoreError: Error {
        case failedVerification
    }
}
