//
//  NetworkError.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    case transport(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "HTTP error: \(code)."
        case .decoding(let err):
            return "Decoding error: \(err.localizedDescription)"
        case .transport(let err):
            return "Network error: \(err.localizedDescription)"
        }
    }
}
