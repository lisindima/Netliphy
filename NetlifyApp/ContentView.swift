//
//  ContentView.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    var body: some View {
        NavigationView {
            LoadingView(
                loadingState: $sessionStore.sitesLoadingState,
                title: "dd",
                subTitle: "eee",
                load: sessionStore.listSites
            ) { sites in
                List {
                    ForEach(sites, id: \.id) { site in
                        Text(site.name)
                    }
                }
            }
            .navigationTitle("Sites")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
