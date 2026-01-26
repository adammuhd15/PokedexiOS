//
//  PokedexListViewController.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import UIKit

class PokedexListViewController: UIViewController, PokedexListViewProtocol {
    var presenter: PokedexListPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var data: [PokemonListItemViewModel] = []
    
    private let refresh = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokedex"
        view.backgroundColor = .systemBackground
        setupTable()
        presenter.viewDidLoad()
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        
        spinner.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    }
    
    @objc private func didPullToRefresh() {
        presenter.didPullToRefresh()
    }
    
    // MARK: - View protocol
    
    func show(items: [PokemonListItemViewModel]) {
        data = items
        tableView.reloadData()
        if refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    func showLoading(_ isLoading: Bool) {
        isLoading ? spinner.startAnimating() : spinner.stopAnimating()
        if !isLoading, refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    func showError(_ message: String) {
        if (refresh.isRefreshing) {
            refresh.endRefreshing()
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PokedexListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.reuseID, for: indexPath) as! PokemonCell
        cell.configure(with: vm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(data[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Trigger pagination when you are close to the bottom
        if indexPath.row >= data.count - 5 {
            presenter.didReachEndOfList()
        }
    }
}
