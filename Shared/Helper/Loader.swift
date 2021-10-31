//
//  API.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import SwiftUI

class Loader {
    @AppStorage("accounts", store: store) var accounts: Accounts = []
    
    let session = URLSession.shared
    
    static let shared = Loader()

    func fetch<T: Decodable>(
        for endpoint: Endpoint,
        httpMethod: HTTPMethod = .get,
        token: String = ""
    ) async throws -> T {
        let (data, response) = try await session.data(for: createRequest(for: endpoint, token: token.isEmpty ? accounts.first?.accessToken : token, httpMethod: httpMethod))
        guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func upload<Parameters: Encodable, T: Decodable>(
        for endpoint: Endpoint,
        parameters: Parameters,
        httpMethod: HTTPMethod = .post,
        token: String = ""
    ) async throws -> T {
        var request = createRequest(for: endpoint, token: token.isEmpty ? accounts.first?.accessToken : token, httpMethod: httpMethod)
        request.httpBody = try? encoder.encode(parameters)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func response(
        for endpoint: Endpoint,
        httpMethod: HTTPMethod = .get
    ) async throws {
        _ = try await session.data(for: createRequest(for: endpoint, token: accounts.first?.accessToken, httpMethod: httpMethod))
    }
}

extension Loader {
    func createRequest(
        for endpoint: Endpoint,
        token: String?,
        httpMethod: HTTPMethod
    ) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = httpMethod.rawValue
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategyFormatters = [.netlifyFormatter, .iso8601]
        return decoder
    }
    
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .formatted(.netlifyFormatter)
        return encoder
    }
}

enum LoaderError: Error {
    case invalidServerResponse
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}

extension JSONDecoder {
    var dateDecodingStrategyFormatters: [DateFormatter]? {
        get { nil }
        set {
            guard let formatters = newValue else { return }
            dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                for formatter in formatters {
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
        }
    }
}
