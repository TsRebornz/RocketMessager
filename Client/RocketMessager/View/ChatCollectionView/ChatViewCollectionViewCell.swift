//
//  ChatViewCollectionViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 14.05.24.
//

import UIKit

final class ChatViewCollectionViewCell: UICollectionViewCell {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    func setModel(_ model: MessageModel) {
        textLabel.text = model.text
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .yellow
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate(
            [
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}
