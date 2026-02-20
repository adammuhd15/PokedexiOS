//
//  PokemonDetailInteractor.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import Foundation

final class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    private let api: APIClientProtocol
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func fetchPokemonDetail(idOrName: String) async -> Result<PokemonDetailDTO, NetworkError> {
        await api.get(.pokemonDetail(idOrName: idOrName))
    }
}
