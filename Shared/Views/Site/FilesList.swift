//
//  FilesList.swift
//  FilesList
//
//  Created by Дмитрий on 01.09.2021.
//

import SwiftUI

struct FilesList: View {
    @StateObject private var viewModel = FilesViewModel()
    
    let siteId: String
    
    var body: some View {
        LoadingView(viewModel.loadingState) { files in
            List {
                ForEach(files, content: FileItems.init)
            }
        }
        .navigationTitle("Files")
        .task {
            await viewModel.load(siteId)
        }
    }
}

struct FileItems_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FileItems(file: .placeholder)
        }
    }
}
