//
//  DeployDetails.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.03.2021.
//

import SwiftUI

struct DeployDetails: View {
    @Environment(\.presentationMode) @Binding private var presentationMode
    
    @State private var deployLoadingState: LoadingState<Deploy> = .loading(.placeholder)
    
    let deployId: String
    
    var body: some View {
        LoadingView(
            loadingState: $deployLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { deploy in
            List {
                if case .ready = deploy.state {
                    Section(header: Text("section_header_summary_deploy")) {
                        if let summary = deploy.summary {
                            ForEach(summary.messages, id: \.id, content: SummaryItems.init)
                        }
                    }
                }
                Section(header: Text("section_header_status_deploy")) {
                    StateView(deploy: deploy)
                }
                if case .building = deploy.state {
                    Button("button_title_cancel_deploy") {
                        async {
                            await cancelDeploy()
                        }
                    }
                } else {
                    Button("button_title_retry_deploy") {
                        async {
                            await retryDeploy()
                        }
                    }
                }
                Section(header: Text("section_header_info_deploy")) {
                    if let createdAt = deploy.createdAt {
                        FormItems("Deploy created", value: createdAt.formatted())
                    }
                    if let updatedAt = deploy.updatedAt {
                        FormItems("Deploy updated", value: updatedAt.formatted())
                    }
                    FormItems("Site name", value: deploy.name)
                    if let deployTime = deploy.deployTime {
                        FormItems("Deploy time", value: deployTime.convertedDeployTime(.full))
                    }
                    if let errorMessage = deploy.errorMessage {
                        FormItems("Error message", value: errorMessage)
                    }
                    if let framework = deploy.framework {
                        FormItems("Framework", value: framework)
                    }
                    Link("button_open_deploy_url", destination: deploy.deployUrl)
                }
                if !deploy.manualDeploy {
                    Section(header: Text("section_header_commit_information")) {
                        if let branch = deploy.branch {
                            FormItems("Branch", value: branch)
                        }
                        if let title = deploy.title {
                            FormItems("Title", value: title)
                        }
                        if let committer = deploy.committer {
                            FormItems("Committer", value: committer)
                        }
                        if let commitUrl = deploy.commitUrl, let commitRef = deploy.commitRef {
                            Link("button_title_view_commit \(String(commitRef.prefix(7)))", destination: commitUrl)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: LogView(logAccessAttributes: deploy.logAccessAttributes)) {
                        Label("section_navigation_link_log", systemImage: "rectangle.and.text.magnifyingglass")
                    }
                }
            }
            .refreshable {
                await getDeploy()
            }
        }
        .navigationTitle(deployId)
        .onAppear {
            async {
                await getDeploy()
            }
        }
        .userActivity("com.darkfox.netliphy.deploy", element: deployId) { id, activity in
            activity.addUserInfoEntries(
                from: [
                    "url": URL(string: "netliphy://open?deployId=\(id)")!,
                ]
            )
        }
    }
    
    let loader = Loader()
    
    private func getDeploy() async {
        do {
            let value: Deploy = try await loader.fetch(.deploy(deployId: deployId))
            deployLoadingState = .success(value)
        } catch {
            deployLoadingState = .failure(error)
            print(error)
        }
    }
    
    private func retryDeploy() async {
        do {
            _ = try await loader.response(.retry(deployId: deployId), httpMethod: .post)
            DispatchQueue.main.async {
                presentationMode.dismiss()
            }
        } catch {
            print(error)
        }
    }
    
    private func cancelDeploy() async {
        do {
            _ = try await loader.response(.cancel(deployId: deployId), httpMethod: .post)
            DispatchQueue.main.async {
                presentationMode.dismiss()
            }
        } catch {
            print(error)
        }
    }
}
