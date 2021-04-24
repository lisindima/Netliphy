//
//  NoAccount.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 24.04.2021.
//

import SwiftUI

struct NoAccount: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("title_no_account")
                .fontWeight(.bold)
            Text("subTitle_no_account")
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
    }
}
