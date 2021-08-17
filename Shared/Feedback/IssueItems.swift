//
//  IssueItems.swift
//  IssueItems
//
//  Created by Дмитрий Лисин on 17.08.2021.
//

import SwiftUI

struct IssueItems: View {
    let issue: Issue
    
    var body: some View {
        Link(destination: issue.htmlUrl) {
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(issue.state.color)
                    .frame(width: 7)
                VStack(alignment: .leading) {
                    Text(issue.title)
                        .foregroundColor(.primary)
                        .font(.footnote.weight(.bold))
                        .lineLimit(1)
                    Text(issue.body)
                        .foregroundColor(.primary)
                        .font(.footnote)
                        .lineLimit(2)
                    issue.updateLabel
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
        }
    }
}

struct IssueItems_Previews: PreviewProvider {
    static var previews: some View {
        IssueItems(issue: .placeholder)
    }
}
