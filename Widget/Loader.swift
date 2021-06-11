//
//  Loader.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.06.2021.
//

import SwiftUI
import Combine

class Loader {
    @AppStorage("accessToken", store: UserDefaults(suiteName: "group.darkfox.netliphy"))
    var accessToken: String = ""
    
    private var requests = Set<AnyCancellable>()
    
    static let shared = Loader()
    
    private func createRequest(_ endpoint: Endpoint, httpMethod: HTTPMethod, setToken: Bool = true) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.allowsExpensiveNetworkAccess = true
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
    
    func fetch<T: Decodable>(
        _ endpoint: Endpoint,
        httpMethod: HTTPMethod = .get,
        setToken: Bool = true,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        URLSession.shared.dataTaskPublisher(for: createRequest(endpoint, httpMethod: httpMethod, setToken: setToken))
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .map(Result.success)
            .catch { error -> Just<Result<T, ApiError>> in
                error is DecodingError
                    ? Just(.failure(.decodeFailed(error)))
                    : Just(.failure(.uploadFailed(error)))
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: completion)
            .store(in: &requests)
    }
}
