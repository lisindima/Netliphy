//
//  IssueList.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 17.08.2021.
//

import SwiftUI

struct IssueList: View {
    @StateObject private var viewModel = FeedbackViewModel()
    
    @State private var openNewFeedback: Bool = false
    
    var body: some View {
        LoadingView(viewModel.loadingState) { issues in
            List {
                ForEach(issues, content: IssueItems.init)
            }
        }
        .navigationTitle("You Feedbacks")
        .sheet(isPresented: $openNewFeedback) {
            FeedbackView()
        }
        .toolbar {
            Button {
                openNewFeedback = true
            } label: {
                Label("Add new feedback", systemImage: "plus.circle.fill")
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
