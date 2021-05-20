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
            StateWidgetView(title: "error_state", color: .red)
        case .ready:
            StateWidgetView(title: "ready_state", color: .green)
        case .new:
            StateWidgetView(title: "new_state", color: .purple)
        case .building:
            StateWidgetView(title: "building_state", color: .yellow)
        case .enqueued:
            StateWidgetView(title: "enqueued_state", color: .gray)
        }
    }
}
