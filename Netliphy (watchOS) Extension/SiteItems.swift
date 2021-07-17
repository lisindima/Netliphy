//
//  SiteItems.swift
//  SiteItems
//
//  Created by Дмитрий Лисин on 17.07.2021.
//

import SwiftUI

struct SiteItems: View {
    let site: Site
    
    var body: some View {
        NavigationLink {
            SiteDetails(site: site)
        } label: {
            VStack {
                AsyncImage(url: site.screenshotUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                }
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .padding(.vertical, 8)
                VStack(alignment: .leading) {
                    Text(site.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    site.lastUpdate
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
