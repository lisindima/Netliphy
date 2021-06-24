//
//  API.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Combine
import SwiftUI

class Loader {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    let session = URLSession.shared
    
    static let shared = Loader()

    func fetch<T: Decodable>(
        _ endpoint: Endpoint,
        httpMethod: HTTPMethod = .get,
        setToken: Bool = true
    ) async throws -> T {
        let (data, response) = try await session.data(for: createRequest(endpoint, token: accessToken, httpMethod: httpMethod, setToken: setToken))
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func upload<Parameters: Encodable, T: Decodable>(
        _ endpoint: Endpoint,
        parameters: Parameters,
        httpMethod: HTTPMethod = .post
    ) async throws -> T {
        var request = createRequest(endpoint, token: accessToken, httpMethod: httpMethod)
        request.httpBody = try? encoder.encode(parameters)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw LoaderError.invalidServerResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func response(
        _ endpoint: Endpoint,
        httpMethod: HTTPMethod = .get,
        setToken: Bool = true
    ) async throws {
        _ = try await session.data(for: createRequest(endpoint, token: accessToken, httpMethod: httpMethod, setToken: setToken))
    }
}

func createRequest(_ endpoint: Endpoint, token: String, httpMethod: HTTPMethod, setToken: Bool = true) -> URLRequest {
    var request = URLRequest(url: endpoint.url)
    request.httpMethod = httpMethod.rawValue
    if setToken {
        request.setValue(token, forHTTPHeaderField: "Authorization")
    }
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
