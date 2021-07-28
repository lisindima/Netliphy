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
            StateWidgetView(title: "Error", color: .red)
        case .ready:
            StateWidgetView(title: "Ready", color: .green)
        case .new:
            StateWidgetView(title: "New", color: .blue)
        case .building:
            StateWidgetView(title: "Building", color: .yellow)
        case .enqueued:
            StateWidgetView(title: "Queued", color: .gray)
        case .processing:
            StateWidgetView(title: "Processing", color: .brown)
        }
    }
}
