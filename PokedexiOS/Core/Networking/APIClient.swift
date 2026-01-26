//
//  APIClient.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError>
}

final class APIClient: APIClientProtocol {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError> {
        guard let url = endpoint.url(baseURL: baseURL) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            guard (200...299).contains(http.statusCode) else {
                return .failure(.httpStatus(http.statusCode))
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } catch {
                return .failure(.decoding(error))
            }
        } catch {
            return .failure(.transport(error))
        }
    }
}
