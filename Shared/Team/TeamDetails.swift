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
                LoadingView(
                    loadingState: viewModel.bandwidthLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { bandwidth in
                    ProgressView(
                        value: bandwidth.used,
                        total: bandwidth.included,
                        label: {
                            Text("progress_view_bandwidth")
                                .fontWeight(.bold)
                            Text("progress_view_updated \(bandwidth.lastUpdatedAt.formatted())")
                                .font(.caption2)
                        },
                        currentValueLabel: {
                            HStack {
                                Text(bandwidth.used.byteSize)
                                Spacer()
                                Text(bandwidth.included.byteSize)
                            }
                        }
                    )
                }
            }
            .task {
                await viewModel.getBandwidth(team.slug)
            }
            Section {
                LoadingView(
                    loadingState: viewModel.statusLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { status in
                    ProgressView(
                        value: Float(status.minutes.current),
                        total: Float(status.minutes.includedMinutes),
                        label: {
                            Text("progress_view_build_minutes")
                                .fontWeight(.bold)
                            Text("progress_view_updated \(status.minutes.lastUpdatedAt.formatted())")
                                .font(.caption2)
                        },
                        currentValueLabel: {
                            HStack {
                                Text(status.minutes.current.convertToMinute)
                                Spacer()
                                Text(status.minutes.includedMinutes.convertToMinute)
                            }
                        }
                    )
                }
            }
            .task {
                await viewModel.getStatus(team.slug)
            }
            Section {
                LoadingView(
                    loadingState: viewModel.membersLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { members in
                    ForEach(members, id: \.id, content: MemberItems.init)
                }
            }
            .task {
                await viewModel.listMembersForAccount(team.slug)
            }
            Section {
                FormItems("Name", value: team.name)
                FormItems("Type", value: team.typeName)
                FormItems("Members count", value: "\(team.membersCount)")
                FormItems("Slug", value: team.slug)
                if let billingName = team.billingName {
                    FormItems("Billing name", value: billingName)
                }
                if let billingEmail = team.billingEmail {
                    FormItems("Billing email", value: billingEmail)
                }
                if let billingPeriod = team.billingPeriod {
                    FormItems("Billing period", value: billingPeriod)
                }
                if let billingDetails = team.billingDetails {
                    FormItems("Billing details", value: billingDetails)
                }
            }
        }
        .refreshable {
            await viewModel.all(team.slug)
        }
        .navigationTitle(team.name)
    }
}
