//
//  API.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Combine
import SwiftUI

struct Loader {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    let session = URLSession.shared
    
    private func createRequest(_ endpoint: Endpoint, httpMethod: HTTPMethod, setToken: Bool = true) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = httpMethod.rawValue
        if setToken {
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .customISO8601
        return decoder
    }
    
    private var encoder: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }

    func fetch<T: Decodable>(
        _ endpoint: Endpoint,
        httpMethod: HTTPMethod = .get,
        setToken: Bool = true
    ) async throws -> T {
        let (data, response) = try await session.data(for: createRequest(endpoint, httpMethod: httpMethod, setToken: setToken))
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
        var request = createRequest(endpoint, httpMethod: httpMethod)
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
    ) async throws -> URLResponse {
        let (_, response) = try await session.data(for: createRequest(endpoint, httpMethod: httpMethod, setToken: setToken))
        return response
    }
}
