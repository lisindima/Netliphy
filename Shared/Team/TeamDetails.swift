//
//  TeamDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI

struct TeamDetails: View {
    let team: Team
    
    @State private var bandwidthLoadingState: LoadingState<Bandwidth> = .loading(.placeholder)
    @State private var statusLoadingState: LoadingState<BuildStatus> = .loading(.placeholder)
    @State private var membersLoadingState: LoadingState<[Member]> = .loading(Array(repeating: .placeholder, count: 1))
    
    var body: some View {
        List {
            Section {
                LoadingView(
                    loadingState: $bandwidthLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { bandwidth in
                    ProgressView(
                        value: Float(bandwidth.used),
                        total: Float(bandwidth.included),
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
                .task {
                    await getBandwidth()
                }
            }
            Section {
                LoadingView(
                    loadingState: $statusLoadingState,
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
                                Text("progress_view_minutes \(status.minutes.current)")
                                Spacer()
                                Text("progress_view_minutes \(status.minutes.includedMinutes)")
                            }
                        }
                    )
                }
                .task {
                    await getStatus()
                }
            }
            Section {
                LoadingView(
                    loadingState: $membersLoadingState,
                    failure: { error in
                        FailureFormView(error.localizedDescription)
                    }
                ) { members in
                    ForEach(members, id: \.id, content: MemberItems.init)
                }
                .task {
                    await listMembersForAccount()
                }
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
        .navigationTitle(team.name)
    }
    
    private func getBandwidth() async {
        do {
            let value: Bandwidth = try await Loader.shared.fetch(.bandwidth(slug: team.slug))
            bandwidthLoadingState = .success(value)
        } catch {
            bandwidthLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func getStatus() async {
        do {
            let value: BuildStatus = try await Loader.shared.fetch(.status(slug: team.slug))
            statusLoadingState = .success(value)
        } catch {
            statusLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func listMembersForAccount() async {
        do {
            let value: [Member] = try await Loader.shared.fetch(.members(slug: team.slug))
            membersLoadingState = .success(value)
        } catch {
            membersLoadingState = .failure(error)
            print(error)
        }
    }
}
