//
//  LogFile.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 17.03.2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct LogFile: FileDocument {
    static var readableContentTypes = [UTType.plainText]
    
    var logs = ""

    init(_ logs: String) {
        self.logs = logs
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            logs = String(decoding: data, as: UTF8.self)
        }
    }

    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        let data = Data(logs.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
