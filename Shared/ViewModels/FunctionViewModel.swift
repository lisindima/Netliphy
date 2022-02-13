//
//  FunctionViewModel.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

@MainActor
class FunctionViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<FunctionInfo> = .loading(.placeholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        
        do {
            let value: FunctionInfo = try await Loader.shared.fetch(for: .functions(siteId))
            if Task.isCancelled { return }
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("listFunctions", error)
        }
    }
}
