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
        Text(team.slug)
            .navigationTitle(team.name)
    }
}
