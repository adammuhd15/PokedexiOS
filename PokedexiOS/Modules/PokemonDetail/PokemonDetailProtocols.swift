//
//  PokemonDetailProtocols.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import UIKit

protocol PokemonDetailViewProtocol: AnyObject {
    func showLoading(_ isLoading: Bool)
    func show(viewModel: PokemonDetailViewModel)
    func showError(_ message: String)
}

protocol PokemonDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol PokemonDetailInteractorProtocol: AnyObject {
    func fetchPokemonDetail(idOrName: String) async -> Result<PokemonDetailDTO, NetworkError>
}

protocol PokemonDetailRouterProtocol: AnyObject {
    // Reserved for future navigation from detail
}
