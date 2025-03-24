//
//  ChatListTableViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 18.03.25.
//

import UIKit

final class ChatListTableViewCell: UITableViewCell {
    
    enum Config {
        enum Layout {
            static let horizontalInset = 24.0
            static let verticalInset = 15.0
            static let imageSizeSide: CGFloat = 50.0
        }
        
        enum Colors {
            static let nameLabelTextColor: UIColor = DesignColors.UserList.titleTextColor
            static let statusLabelTextColor: UIColor = DesignColors.UserList.statusTextColor
        }
        
        enum Fonts {
            static let nameLabelFont = UIFont.systemFont(ofSize: 20, weight: .medium)
            static let statusLabelFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
    
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
        label.font = Config.Fonts.nameLabelFont
        label.textColor = Config.Colors.nameLabelTextColor
        return label
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Config.Fonts.statusLabelFont
        label.textColor = Config.Colors.statusLabelTextColor
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
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
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Config.Layout.horizontalInset
            ),
            avatarImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Config.Layout.verticalInset
            ),
            avatarImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Config.Layout.verticalInset
            ),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor)
        ])
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -15
            )
        ])
    }
}
