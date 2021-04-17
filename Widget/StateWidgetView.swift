//
//  StateWidgetView.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 17.04.2021.
//

import SwiftUI

struct StateWidgetView: View {
    let title: String
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
