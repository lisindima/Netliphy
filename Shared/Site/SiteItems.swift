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
        NavigationLink(destination: SiteDetails(site: site)) {
            HStack {
                AsyncImage(url: site.screenshotUrl) { image in
                    image
                        .resizable()
                        .frame(width: 96, height: 60)
                        .cornerRadius(5)
                        .padding(.vertical, 8)
                    
                } placeholder: {
                    Image("placeholder")
                        .resizable()
                        .frame(width: 96, height: 60)
                        .cornerRadius(5)
                        .padding(.vertical, 8)
                }
                VStack(alignment: .leading) {
                    Text(site.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    HStack {
                        Text("site_items_last_deploy") +
                            Text(site.updatedAt, style: .relative) +
                            Text("site_items_ago")
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            }
            .contextMenu {
                Link(destination: site.url) {
                    Label("button_open_site", systemImage: "safari.fill")
                }
                Link(destination: site.adminUrl) {
                    Label("button_admin_panel", systemImage: "wrench.and.screwdriver.fill")
                }
                if let repoUrl = site.buildSettings.repoUrl {
                    Link(destination: repoUrl) {
                        Label("button_open_repository", systemImage: "tray.full.fill")
                    }
                }
            }
        }
    }
}
