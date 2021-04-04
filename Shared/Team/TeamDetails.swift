//
//  TeamDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI

struct TeamDetails: View {
    var team: Team
    
    var body: some View {
        Form {
            Section(header: Text("Team overview")) {
                Group {
                    ProgressView(
                        value: Float(team.capabilities.bandwidth.used),
                        total: Float(team.capabilities.bandwidth.included),
                        label: {
                            Text("progress_view_bandwidth")
                                .fontWeight(.bold)
                        },
                        currentValueLabel: {
                            HStack {
                                Text(team.capabilities.bandwidth.used.byteSize)
                                Spacer()
                                Text(team.capabilities.bandwidth.included.byteSize)
                            }
                        }
                    )
                    ProgressView(
                        value: Float(team.capabilities.collaborators.used),
                        total: Float(team.capabilities.collaborators.included)
                    ) {
                        Text("Collaborators")
                            .fontWeight(.bold)
                    }
                    ProgressView(
                        value: Float(team.capabilities.buildMinutes.used),
                        total: Float(team.capabilities.buildMinutes.included)
                    ) {
                        Text("Build minutes")
                            .fontWeight(.bold)
                    }
                    ProgressView(
                        value: Float(team.capabilities.sites.used),
                        total: Float(team.capabilities.sites.included)
                    ) {
                        Text("Sites")
                            .fontWeight(.bold)
                    }
                    ProgressView(
                        value: Float(team.capabilities.domains.used),
                        total: Float(team.capabilities.domains.included)
                    ) {
                        Text("Domains")
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical, 6)
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
}
