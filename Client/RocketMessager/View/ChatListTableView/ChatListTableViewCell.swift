//
//  ChatListTableViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 18.03.25.
//

import UIKit

final class ChatListTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ChatListTableViewCell"
    
    // MARK: - Properties
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Initializers
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setup() {
        nameLabel.text = "Name"
        statusLabel.text = "Status"
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
}
