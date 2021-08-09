//
//  API.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Combine
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
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func upload<Parameters: Encodable, T: Decodable>(
        for endpoint: Endpoint,
        parameters: Parameters,
        httpMethod: HTTPMethod = .post
    ) async throws -> T {
        var request = createRequest(for: endpoint, token: accounts.first?.accessToken, httpMethod: httpMethod)
        request.httpBody = try? encoder.encode(parameters)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
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
    decoder.dateDecodingStrategy = .customISO8601
    return decoder
}

var encoder: JSONEncoder {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dataEncodingStrategy = .base64
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    return encoder
}
