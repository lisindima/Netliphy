//
//  FunctionList.swift
//  Netliphy
//
//  Created by Дмитрий on 31.10.2021.
//

import SwiftUI

struct FunctionList: View {
    @StateObject private var viewModel = FunctionViewModel()
    
    let siteId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { value in
            List {
                ForEach(value.functions) { function in
                    FunctionItems(function: function, siteId: siteId)
                }
            }
            .refreshable {
                await viewModel.load(siteId)
            }
        }
        .navigationTitle("Functions")
        .task {
            await viewModel.load(siteId)
        }
    }
}
