//
//  PokedexListInteractor.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import Foundation

final class PokedexListInteractor: PokedexListInteractorProtocol {
    private let api: APIClientProtocol
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func fetchPokemonList(limit: Int, offset: Int) async -> Result<PokemonListResponseDTO, NetworkError> {
        await api.get(.pokemonList(limit: limit, offset: offset))
    }
}
