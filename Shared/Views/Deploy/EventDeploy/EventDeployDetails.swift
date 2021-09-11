//
//  EventDeployDetails.swift
//  EventDeployDetails
//
//  Created by Дмитрий on 11.09.2021.
//

import SwiftUI

struct EventDeployDetails: View {
    let event: EventDeploy
    
    var body: some View {
        List {
            Section {
                FormItems("Event created", value: event.createdAt.formatted())
                FormItems("Event updated", value: event.updatedAt.formatted())
            }
            Section {
                FormItems("Browser", value: event.browser)
                FormItems("Engine", value: event.engine)
                FormItems("Cookies", value: String(event.metadata.cookies))
                FormItems("OS", value: event.os)
                FormItems("Viewport", value: event.viewport)
                FormItems("Mobile?", value: String(event.metadata.device.mobile))
            }
            Section {
                FormItems("User", value: event.user.fullName)
                FormItems("Email", value: event.user.email)
                FormItems("User-agent", value: event.metadata.ua)
                FormItems("Language", value: event.metadata.language)
                FormItems("IP", value: event.metadata.ip)
            }
            Section {
                Link("Open Browserstack", destination: event.metadata.browserstackUrl)
            }
        }
        .navigationTitle(event.id)
    }
}
