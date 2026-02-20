//
//  PokemonDetailViewController.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 20/02/2026.
//

import UIKit

class PokemonDetailViewController: UIViewController, PokemonDetailViewProtocol {
    var presenter: PokemonDetailPresenterProtocol!
    
    private let imageLoader: ImageLoaderProtocol = ImageLoader.shared
    private var imageToken: Cancellable?
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let spriteView = UIImageView()
    private let nameLabel = UILabel()
    private let typesLabel = UILabel()
    private let metaLabel = UILabel()
    
    private let statsTitleLabel = UILabel()
    private let statsStack = UIStackView()
    
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        // Scroll
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        // Header UI
        spriteView.contentMode = .scaleAspectFit
        spriteView.clipsToBounds = true
        spriteView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .largeTitle)
        nameLabel.numberOfLines = 0
        
        typesLabel.font = .preferredFont(forTextStyle: .headline)
        typesLabel.textColor = .secondaryLabel
        typesLabel.numberOfLines = 0
        
        metaLabel.font = .preferredFont(forTextStyle: .body)
        metaLabel.textColor = .secondaryLabel
        metaLabel.numberOfLines = 0
        
        // Stats
        statsTitleLabel.font = .preferredFont(forTextStyle: .title2)
        statsTitleLabel.text = "Stats"
        
        statsStack.axis = .vertical
        statsStack.spacing = 8
        
        contentStack.addArrangedSubview(spriteView)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(typesLabel)
        contentStack.addArrangedSubview(metaLabel)
        contentStack.addArrangedSubview(statsTitleLabel)
        contentStack.addArrangedSubview(statsStack)
        
        // Spinner overlay
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - View Protocol
    func showLoading(_ isLoading: Bool) {
        isLoading ? spinner.startAnimating() : spinner.stopAnimating()
    }
    
    func show(viewModel: PokemonDetailViewModel) {
        title = "#\(viewModel.id)"
        nameLabel.text = viewModel.displayName
        typesLabel.text = viewModel.typesText
        metaLabel.text = "\(viewModel.heightText) • \(viewModel.weightText)"
        
        // Stats rows
        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in viewModel.stats {
            let row = makeStatRow(name: item.name, value: item.value)
            statsStack.addArrangedSubview(row)
        }
        
        // Sprite image
        spriteView.image = UIImage(systemName: "photo")
        imageToken?.cancel()
        imageToken = nil
        
        guard let url = viewModel.spriteURL else { return }
        
        if let cached = imageLoader.cachedImage(for: url) {
            spriteView.image = cached
            return
        }
        
        imageToken = imageLoader.load(url) { [weak self] image in
            self?.spriteView.image = image
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func makeStatRow(name: String, value: Int) -> UIView {
        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.text = name
        
        let valueLabel = UILabel()
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.text = "\(value)"
        
        let row = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
        row.axis = .horizontal
        row.spacing = 8
        return row
    }
}
