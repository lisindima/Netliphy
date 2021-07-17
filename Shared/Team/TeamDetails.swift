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
            Section {
                LoadingView(viewModel.bandwidthLoadingState) { bandwidth in
                    ProgressView(value: bandwidth.used, total: bandwidth.included) {
                        Text("Bandwidth used")
                            .fontWeight(.bold)
                        Text("Updated \(bandwidth.lastUpdatedAt.formatted())")
                            .font(.caption2)
                    } currentValueLabel: {
                        HStack {
                            Text(bandwidth.used.byteSize)
                            Spacer()
                            Text(bandwidth.included.byteSize)
                        }
                    }
                }
            }
            .task {
                await viewModel.getBandwidth(team.slug)
            }
            Section {
                LoadingView(viewModel.statusLoadingState) { status in
                    ProgressView(value: Float(status.minutes.current), total: Float(status.minutes.includedMinutes)) {
                        Text("Build minutes used")
                            .fontWeight(.bold)
                        Text("Updated \(status.minutes.lastUpdatedAt.formatted())")
                            .font(.caption2)
                    } currentValueLabel: {
                        HStack {
                            Text(status.minutes.current.convertToMinute)
                            Spacer()
                            Text(status.minutes.includedMinutes.convertToMinute)
                        }
                    }
                }
            }
            .task {
                await viewModel.getStatus(team.slug)
            }
            Section {
                LoadingView(viewModel.membersLoadingState) { members in
                    ForEach(members, id: \.id, content: MemberItems.init)
                }
            }
            .task {
                await viewModel.listMembersForAccount(team.slug)
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
        .refreshable {
            await viewModel.load(team.slug)
        }
        .navigationTitle(team.name)
    }
}
