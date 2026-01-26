//
//  PokedexListRouter.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import UIKit

final class PokedexListRouter: PokedexListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = PokedexListViewController()
        let api = APIClient()
        let interactor = PokedexListInteractor(api: api)
        let router = PokedexListRouter()
        let presenter = PokedexListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
    func navigateToDetail(from view: UIViewController, id: Int, name: String) {
        // Stub for now - you'll replace with PokemonDetailRouter.createModule(...)
        let detail = UIViewController()
        detail.view.backgroundColor = .systemBackground
        detail.title = "\(name.prefix(1).uppercased())\(name.dropFirst()) #\(id)"
        view.navigationController?.pushViewController(detail, animated: true)
    }
}
