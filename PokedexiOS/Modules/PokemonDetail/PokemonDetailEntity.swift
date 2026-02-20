//
//  PokemonDetailEntity.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import Foundation

// DTO for /pokemon/{id or name}
struct PokemonDetailDTO: Decodable {
    struct PokemonTypeEntry: Decodable {
        struct TypeResource: Decodable { let name: String }
        let type: TypeResource
        let slot: Int
    }
    
    struct PokemonStatEntry: Decodable {
        struct StatResource: Decodable { let name: String }
        let base_stat: Int
        let stat: StatResource
    }
    
    struct Sprites: Decodable {
        let front_default: String?
    }
    
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let stats: [PokemonStatEntry]
}

// ViewModel used by the detail UI
struct PokemonDetailViewModel {
    let id: Int
    let displayName: String
    let spriteURL: URL?
    let typesText: String
    let heightText: String
    let weightText: String
    let stats: [(name: String, value: Int)]
}

enum PokemonDetailMapper {
    static func map(dto: PokemonDetailDTO) -> PokemonDetailViewModel {
        let displayName = dto.name.prefix(1).uppercased() + dto.name.dropFirst()
        
        let typesSorted = dto.types.sorted { $0.slot < $1.slot }.map { $0.type.name }
        let typesText = typesSorted.map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined(separator: " • ")
        
        // PokeAPI: height in decimetres, weight in hectograms.
        let heightM = Double(dto.height) / 10.0
        let weightKg = Double(dto.weight) / 10.0
        
        let spriteURL = dto.sprites.front_default.flatMap { URL(string: $0) }
        
        let stats = dto.stats.map { entry in
            let name = entry.stat.name.replacingOccurrences(of: "-", with: " ").capitalized
            return (name: name, value: entry.base_stat)
        }
        
        return PokemonDetailViewModel(
            id: dto.id,
            displayName: displayName,
            spriteURL: spriteURL,
            typesText: typesText,
            heightText: String(format: "Height: %.1f m", heightM),
            weightText: String(format: "Weight: %.1f kg", weightKg),
            stats: stats
        )
    }
}
