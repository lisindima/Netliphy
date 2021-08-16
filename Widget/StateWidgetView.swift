//
//  StateWidgetView.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 17.04.2021.
//

import SwiftUI

struct StateWidgetView: View {
    let title: LocalizedStringKey
    let color: Color
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.black)
                .font(.system(.body, design: .rounded))
                .textCase(.uppercase)
        }
    }
}

extension DeployState {
    @ViewBuilder
    var widget: some View {
        switch self {
        case .error:
            StateWidgetView(title: "Error", color: color)
        case .ready:
            StateWidgetView(title: "Ready", color: color)
        case .new:
            StateWidgetView(title: "New", color: color)
        case .building:
            StateWidgetView(title: "Building", color: color)
        case .enqueued:
            StateWidgetView(title: "Queued", color: color)
        case .processing:
            StateWidgetView(title: "Processing", color: color)
        }
    }
}
