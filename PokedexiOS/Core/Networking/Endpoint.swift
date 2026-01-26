//
//  Endpoint.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
    
    func url(baseURL: URL) -> URL? {
        var comps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        let existingPath = comps?.path ?? ""
        comps?.path = existingPath + path
        comps?.queryItems = queryItems.isEmpty ? nil : queryItems
        return comps?.url
    }
}

extension Endpoint {
    static func pokemonList(limit: Int, offset: Int) -> Endpoint {
        Endpoint(
            path: "/pokemon",
            queryItems: [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)"),
            ]
        )
    }
    
    static func pokemonDetail(idOrName: String) -> Endpoint {
        Endpoint(path: "/pokemon/\(idOrName)")
    }
}
