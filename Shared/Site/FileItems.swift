//
//  FileItems.swift
//  FileItems
//
//  Created by Дмитрий on 03.09.2021.
//

import SwiftUI

struct FileItems: View {
    let file: File
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(file.path)
                .fontWeight(.bold)
            Text(file.sha)
                .font(.footnote)
            HStack {
                Text(file.mimeType)
                Spacer()
                Text(file.size.byteSize)
            }
            .foregroundColor(.secondary)
            .font(.caption2)
        }
    }
}
