//
//  ChatListTableViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 07.03.25.
//

import UIKit

final class ChatListTableViewCell: UITableViewCell {
    static let cellIdentifier = "ChatListTableViewCell"
    
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15)
        ])
    }
}

final class ChatListTableViewController: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListTableViewCell.cellIdentifier,
            for: indexPath
        ) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func setupUI() {
        tableView.register(
            ChatListTableViewCell.self,
            forCellReuseIdentifier: ChatListTableViewCell.cellIdentifier
        )
        tableView.rowHeight = 64
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}
