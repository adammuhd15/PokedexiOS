//
//  PokemonCell.swift
//  PokedexiOS
//
//  Created by Adam Muhammad on 26/01/2026.
//

import UIKit

class PokemonCell: UITableViewCell {
    static let reuseID = "PokemonCell"
    
    private let spriteView = UIImageView()
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    
    private var imageTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        spriteView.image = nil
    }
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        spriteView.translatesAutoresizingMaskIntoConstraints = false
        spriteView.contentMode = .scaleAspectFit
        spriteView.clipsToBounds = true
        spriteView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        spriteView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        idLabel.font = .preferredFont(forTextStyle: .subheadline)
        idLabel.textColor = .secondaryLabel
        
        let labels = UIStackView(arrangedSubviews: [nameLabel, idLabel])
        labels.axis = .vertical
        labels.spacing = 2
        labels.translatesAutoresizingMaskIntoConstraints = false
        
        let root = UIStackView(arrangedSubviews: [spriteView, labels])
        root.axis = .horizontal
        root.alignment = .center
        root.spacing = 2
        root.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(root)
        
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            root.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with vm: PokemonListItemViewModel) {
        nameLabel.text = vm.displayName
        idLabel.text = "#\(vm.id)"
        
        guard let url = vm.spriteURL else { return }
        
        // Minimal image loading (no cache yet). Add NSCache later.
        imageTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, _ in
            guard let self, let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.spriteView.image = image
            }
        })
        imageTask?.resume()
    }
}
