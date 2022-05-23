//
//  SiteDetailsActionContent.swift
//  Netliphy
//
//  Created by Дмитрий on 23.05.2022.
//

import SwiftUI

enum SiteDetailsActionContent: String, CaseIterable, Identifiable {
    case deploys
    case usage
    case plugins
    case functions
    case forms
    case env
    case notifications
    case files
    
    var id: String { rawValue }
    
    @ViewBuilder
    func destination(_ site: Site) -> some View {
        switch self {
        case .deploys:
            DeploysList(site)
        case .usage:
            UsageView(site)
        case .plugins:
            PluginsView(site)
        case .functions:
            FunctionList(site)
        case .forms:
            FormList(site)
        case .env:
            EnvView(site)
        case .notifications:
            NotificationsView(site)
        case .files:
            FilesList(site)
        }
    }
    
    var title: String {
        switch self {
        case .deploys:
            return "Deploys"
        case .usage:
            return "Usage"
        case .plugins:
            return "Plugins"
        case .functions:
            return "Functions"
        case .forms:
            return "Forms"
        case .env:
            return "Environment Variables"
        case .notifications:
            return "Deploy Notifications"
        case .files:
            return "Files"
        }
    }
    
    var message: String {
        switch self {
        case .deploys:
            return "Deploys"
        case .usage:
            return "Usage"
        case .plugins:
            return "In one click, add powerful features to your build workflow with community Build Plugins."
        case .functions:
            return "Write serverless functions that are version-controlled, built, and deployed along with the rest of your Netlify site."
        case .forms:
            return "Manage forms and submissions without any server-side code or JavaScript."
        case .env:
            return "Set environment variables for your build script and add-ons."
        case .notifications:
            return "Turn on notifications to monitor your site's deployment"
        case .files:
            return "Files"
        }
    }
    
    var systemImage: String {
        switch self {
        case .deploys:
            return "bolt.fill"
        case .usage:
            return "bolt.fill"
        case .plugins:
            return "square.stack.3d.down.right.fill"
        case .functions:
            return "square.stack.3d.down.right.fill"
        case .forms:
            return "square.stack.3d.down.right.fill"
        case .env:
            return "tray.full.fill"
        case .notifications:
            return "bell.badge.fill"
        case .files:
            return "doc.on.doc.fill"
        }
    }
}
