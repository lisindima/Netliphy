//
//  TeamDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import SwiftUI

struct TeamDetails: View {
    var team: Team
    
    @State private var bandwidthLoadingState: LoadingState<Bandwidth> = .loading
    
    private func getBandwidth() {
        Endpoint.api.fetch(.bandwidth(slug: team.slug)) { (result: Result<Bandwidth, ApiError>) in
            switch result {
            case let .success(value):
                bandwidthLoadingState = .success(value)
            case let .failure(error):
                bandwidthLoadingState = .failure(error)
                print(error)
            }
        }
    }
    
    var body: some View {
        Form {
            LoadingView(
                loadingState: $bandwidthLoadingState,
                load: getBandwidth
            ) { bandwidth in
                ProgressView(
                    value: Float(bandwidth.used),
                    total: Float(bandwidth.included),
                    label: {
                        Text("progress_view_bandwidth")
                            .fontWeight(.bold)
                        Text(bandwidth.lastUpdatedAt.siteDate)
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
            }
        }
        .navigationTitle(team.name)
    }
}
