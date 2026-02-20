//
//  PokemonDetailRouter.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import UIKit

final class PokemonDetailRouter: PokemonDetailRouterProtocol {
    static func createModule(idOrName: String) -> UIViewController {
        let view = PokemonDetailViewController()
        let api = APIClient()
        let interactor = PokemonDetailInteractor(api: api)
        let router = PokemonDetailRouter()
        let presenter = PokemonDetailPresenter(
            view: view,
            interactor: interactor,
            router: router,
            idOrName: idOrName
        )
        
        view.presenter = presenter
        return view
    }
}
