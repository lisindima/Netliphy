//
//  FunctionLogFilterView.swift
//  FunctionLogFilterView
//
//  Created by Дмитрий Лисин on 25.07.2021.
//

import SwiftUI

struct FunctionLogFilterView: View {
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var filterString: String = ""
    @State private var dateFilterType: DateFilterType = .latest
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Filter by ID, message, log level", text: $filterString)
                }
                Section {
                    Picker("", selection: $dateFilterType.animation()) {
                        ForEach(DateFilterType.allCases) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                if dateFilterType == .custom {
                    Section {
                        DatePicker("From", selection: $fromDate, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("To", selection: $toDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                Section {
                    Button("Clear filters", action: clearFilter)
                        .disabled(!filtersApplied)
                }
            }
            .navigationTitle("Filter")
        }
    }
    
    private var filtersApplied: Bool {
        !filterString.isEmpty || dateFilterType != .latest
    }
    
    private func clearFilter() {
        withAnimation {
            fromDate = Date()
            toDate = Date()
            filterString = ""
            dateFilterType = .latest
        }
    }
    
    enum DateFilterType: String, CaseIterable, Identifiable {
        case latest = "Latest"
        case lastHour = "Last Hour"
        case custom = "Custom"
        
        var id: String { rawValue }
    }
}
