//
//  FunctionView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import SwiftUI

struct FunctionView: View {
    @StateObject private var viewModel = WebSocketViewModel()
    
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    @State private var showFilter: Bool = false
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var filterString: String = ""
    @State private var dateFilterType: DateFilterType = .latest
    
    let function: Function
    let siteId: String
    
    var body: some View {
        List {
            Section {
                FormItems("Function create", value: function.createdAt.formatted())
                FormItems("Runtime", value: function.runtime)
                Link("Open function", destination: function.endpoint)
            }
            Section {
                if viewModel.functionLog.isEmpty {
                    Label {
                        Text("We are waiting for new logs")
                    } icon: {
                        ProgressView()
                            .tint(.accentColor)
                    }
                } else {
                    ScrollView([.horizontal, .vertical]) {
                        VStack(alignment: .leading) {
                            ForEach(filteredLogs(viewModel.functionLog), content: FunctionLogItems.init)
                        }
                    }
                }
            }
        }
        .navigationTitle(function.name)
        .toolbar {
            Button {
                showFilter = true
            } label: {
                Label(filtersApplied ? "Filtered" : "Filter", systemImage: filtersApplied ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
            }
        }
        .sheet(isPresented: $showFilter) {
            FunctionLogFilterView(
                fromDate: $fromDate,
                toDate: $toDate,
                filterString: $filterString,
                dateFilterType: $dateFilterType
            )
        }
        .task(id: dateFilterType) {
            await viewModel.connect(message: message)
        }
        .onDisappear {
            viewModel.disconnect()
        }
    }
    
    private var filtersApplied: Bool {
        !filterString.isEmpty || dateFilterType != .latest
    }
    
    private func filteredLogs(_ functionLog: [FunctionLog]) -> [FunctionLog] {
        functionLog
            .filter { log -> Bool in
                if let requestId = log.requestId, !filterString.isEmpty {
                    return requestId.lowercased().contains(filterString.lowercased())
                } else {
                    return true
                }
            }
            .filter { log -> Bool in
                if let level = log.level, !filterString.isEmpty {
                    return level.lowercased().contains(filterString.lowercased())
                } else {
                    return true
                }
            }
            .filter { log -> Bool in
                if let message = log.message, !filterString.isEmpty {
                    return message.lowercased().contains(filterString.lowercased())
                } else {
                    return true
                }
            }
    }
    
    private var message: WebSocketMessage {
        switch dateFilterType {
        case .latest:
            return WebSocketMessage(
                accessToken: accounts.first?.token,
                accountId: function.account,
                functionId: function.id,
                siteId: siteId
            )
        case .lastHour:
            let minusHour = Calendar.current.date(byAdding: .hour, value: -1, to: fromDate)!
            return WebSocketMessage(
                accessToken: accounts.first?.token,
                accountId: function.account,
                functionId: function.id,
                siteId: siteId,
                from: minusHour,
                to: toDate
            )
        case .custom:
            return WebSocketMessage(
                accessToken: accounts.first?.token,
                accountId: function.account,
                functionId: function.id,
                siteId: siteId,
                from: fromDate,
                to: toDate
            )
        }
    }
}
