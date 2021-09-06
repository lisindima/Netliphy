//
//  TeamDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI

struct TeamDetails: View {
    @StateObject private var viewModel = TeamViewModel()
    
    let team: Team
    
    var body: some View {
        List {
            LoadingView(viewModel.loadingState) { value in
                Section {
                    ProgressView(
                        value: value.bandwidth.start,
                        total: value.bandwidth.finish
                    ) {
                        Text("Bandwidth used")
                            .fontWeight(.bold)
                        Text("Updated \(value.bandwidth.lastUpdatedAt.formatted())")
                            .font(.caption2)
                    } currentValueLabel: {
                        HStack {
                            Text(value.bandwidth.used.byteSize)
                            Spacer()
                            Text(value.bandwidth.included.byteSize)
                        }
                    }
                    ProgressView(
                        value: Float(value.buildStatus.minutes.current),
                        total: Float(value.buildStatus.minutes.includedMinutes)
                    ) {
                        Text("Build minutes used")
                            .fontWeight(.bold)
                        Text("Updated \(value.buildStatus.minutes.lastUpdatedAt.formatted())")
                            .font(.caption2)
                    } currentValueLabel: {
                        HStack {
                            Text(value.buildStatus.minutes.current.convertToMinute)
                            Spacer()
                            Text(value.buildStatus.minutes.includedMinutes.convertToMinute)
                        }
                    }
                }
                Section {
                    ForEach(value.members, content: MemberItems.init)
                }
            }
            Section {
                FormItems("Name", value: team.name)
                FormItems("Account type", value: team.typeName)
                FormItems("Members count", value: "\(team.membersCount)")
                FormItems("Billing name", value: team.billingName)
                FormItems("Billing email", value: team.billingEmail)
                FormItems("Billing period", value: team.billingPeriod)
                FormItems("Billing details", value: team.billingDetails)
            }
        }
        .navigationTitle(team.name)
        .refreshable {
            await viewModel.load(team.slug)
        }
        .task {
            await viewModel.load(team.slug)
        }
    }
}
