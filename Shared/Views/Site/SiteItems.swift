//
//  SiteItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct SiteItems: View {
    let site: Site
    
    var body: some View {
        NavigationLink {
            SiteDetails(site: site)
        } label: {
            HStack {
                AsyncImage(url: site.screenshotUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                }
                .frame(width: 96, height: 60)
                .cornerRadius(5)
                .padding(.vertical, 8)
                VStack(alignment: .leading) {
                    Text(site.name)
                        .fontWeight(.bold)
                    site.lastUpdate
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
