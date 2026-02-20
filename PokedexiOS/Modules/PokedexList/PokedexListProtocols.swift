//
//  PokedexListProtocols.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import UIKit

protocol PokedexListViewProtocol: AnyObject {
    func show(items: [PokemonListItemViewModel])
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

protocol PokedexListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didPullToRefresh()
    func didSelectItem(_ item: PokemonListItemViewModel)
    func didReachEndOfList()
}

protocol PokedexListInteractorProtocol: AnyObject {
    func fetchPokemonList(limit: Int, offset: Int) async -> Result<PokemonListResponseDTO, NetworkError>
}

protocol PokedexListInteractorOutput: AnyObject {
    func didFetchPage(items: [PokemonListItemViewModel], totalCount: Int, isFirstPage: Bool)
    func didFailToFetch(_ error: NetworkError)
}

protocol PokedexListRouterProtocol: AnyObject {
    func navigateToDetail(from view: UIViewController, id: Int, name: String)
}
