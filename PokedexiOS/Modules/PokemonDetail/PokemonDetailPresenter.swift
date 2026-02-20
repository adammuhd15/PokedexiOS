//
//  PokemonDetailPresenter.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import Foundation

final class PokemonDetailPresenter: PokemonDetailPresenterProtocol {
    private weak var view: PokemonDetailViewProtocol?
    private let interactor: PokemonDetailInteractorProtocol
    private let router: PokemonDetailRouterProtocol
    private let idOrName: String
    
    init(
        view: PokemonDetailViewProtocol,
        interactor: PokemonDetailInteractorProtocol,
        router: PokemonDetailRouterProtocol,
        idOrName: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.idOrName = idOrName
    }
    
    func viewDidLoad() {
        view?.showLoading(true)
        
        Task { [weak self] in
            guard let self else { return }
            let result = await interactor.fetchPokemonDetail(idOrName: idOrName)
            
            await MainActor.run {
                self.view?.showLoading(false)
                
                switch result {
                case .success(let dto):
                    let vm = PokemonDetailMapper.map(dto: dto)
                    self.view?.show(viewModel: vm)
                case .failure(let err):
                    self.view?.showError(err.localizedDescription)
                }
            }
        }
    }
}
