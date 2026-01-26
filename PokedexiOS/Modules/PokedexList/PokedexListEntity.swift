//
//  PokedexListEntity.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import Foundation

// DTOs from PokeAPI
struct PokemonListResponseDTO: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [NamedAPIResourceDTO]
}

struct NamedAPIResourceDTO: Decodable {
    let name: String
    let url: String
}

// View models for UI
struct PokemonListItemViewModel: Hashable {
    let id: Int
    let name: String
    let spriteURL: URL?
    
    var displayName: String {
        name.prefix(1).uppercased() + name.dropFirst()
    }
}

enum PokemonIDParser {
    // Extracts the numeric ID from a PokeAPI resource URL like:
    // "https://pokeapi.co/api/v2/pokemon/1/"
    static func parseID(from urlString: String) -> Int? {
        let trimmed = urlString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let last = trimmed.split(separator: "/").last else { return nil }
        return Int(last)
    }
    
    static func spriteURL(for id: Int) -> URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}
