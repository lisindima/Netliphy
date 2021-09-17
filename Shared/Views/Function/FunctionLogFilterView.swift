//
//  FunctionLogFilterView.swift
//  FunctionLogFilterView
//
//  Created by Дмитрий Лисин on 25.07.2021.
//

import SwiftUI

struct FunctionLogFilterView: View {
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var filterString: String
    @Binding var dateFilterType: DateFilterType
    
    @Environment(\.dismiss) private var dismiss
    
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
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
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
}
