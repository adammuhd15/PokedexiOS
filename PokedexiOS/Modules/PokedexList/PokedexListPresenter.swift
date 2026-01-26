//
//  PokedexListPresenter.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import UIKit

final class PokedexListPresenter: PokedexListPresenterProtocol {
    private weak var view: PokedexListViewProtocol?
    private let interactor: PokedexListInteractorProtocol
    private let router: PokedexListRouterProtocol
    
    private var items: [PokemonListItemViewModel] = []
    private var totalCount: Int = 0
    
    private let limit = 20
    private var offset = 0
    private var isLoading = false
    private var hasMore: Bool { items.count < totalCount || totalCount == 0 }
    
    init(
        view: PokedexListViewProtocol? = nil,
        interactor: PokedexListInteractorProtocol,
        router: PokedexListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        loadFirstPage()
    }
    
    func didPullToRefresh() {
        loadFirstPage()
    }
    
    func didReachEndOfList() {
        guard !isLoading, hasMore else { return }
        loadNextPage()
    }
    
    func didSelectItem(_ item: PokemonListItemViewModel) {
        guard let vc = view as? UIViewController else { return }
        router.navigateToDetail(from: vc, id: item.id, name: item.name)
    }
    
    // MARK: - Loading
    
    private func loadFirstPage() {
        offset = 0
        totalCount = 0
        items = []
        view?.show(items: [])
        fetchPage(isFirstPage: true)
    }
    
    private func loadNextPage() {
        offset += limit
        fetchPage(isFirstPage: false)
    }
    
    private func fetchPage(isFirstPage: Bool) {
        guard !isLoading else { return }
        isLoading = true
        view?.showLoading(true)
        
        Task { [weak self] in
            guard let self else { return }
            let result = await interactor.fetchPokemonList(limit: limit, offset: offset)
            
            await MainActor.run {
                self.isLoading = false
                self.view?.showLoading(false)
                
                switch result {
                case .success(let dto):
                    self.totalCount = dto.count
                    let pageItems: [PokemonListItemViewModel] = dto.results.compactMap { res in
                        guard let id = PokemonIDParser.parseID(from: res.url) else { return nil }
                        return PokemonListItemViewModel(
                            id: id,
                            name: res.name,
                            spriteURL: PokemonIDParser.spriteURL(for: id)
                        )
                    }
                    
                    if isFirstPage {
                        self.items = pageItems
                    } else {
                        self.items += pageItems
                    }
                    
                    self.view?.show(items: self.items)
                    
                case .failure(let error):
                    self.view?.showError((error.localizedDescription))
                }
            }
        }
    }
}
