//
//  TipsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import StoreKit
import SwiftUI
import SPConfetti

typealias Transaction = StoreKit.Transaction

@MainActor
class TipsViewModel: ObservableObject {
    @Published private(set) var tips: [Product] = []
    
    var task: Task<Void, Error>?
    
    init() {
        task = listenForTransactions()
    }
    
    deinit {
        task?.cancel()
    }
    
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: [
                "com.darkfox.netliphy.donate.coffee",
                "com.darkfox.netliphy.donate.pizza",
                "com.darkfox.netliphy.donate.sandwich"
            ])

            var tips: [Product] = []

            for product in storeProducts {
                switch product.type {
                case .consumable:
                    tips.append(product)
                case .nonConsumable, .autoRenewable:
                    print(product)
                default:
                    print("Unknown product")
                }
            }
            
            self.tips = sortByPrice(tips)
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            if let purchase = try await purchase(product) {
                SPConfetti.startAnimating(.fullWidthToDown, particles: [.arc, .circle, .heart, .polygon, .star, .triangle], duration: 3)
                print(purchase)
            }
        } catch {
            print("Failed fuel purchase: \(error)")
        }
    }
    
    private func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case let .verified(safe):
            return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
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
    
    private func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { $0.price < $1.price })
    }
    
    enum StoreError: Error {
        case failedVerification
    }
}
