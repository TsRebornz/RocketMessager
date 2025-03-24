//
//  ChatListTableViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 07.03.25.
//

import UIKit

final class ChatListTableViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Private
    
    private let chatListViewModel: ChatListViewModelProtocol
    
    // MARK: - Init
    
    init(chatListViewModel: ChatListViewModelProtocol) {
        self.chatListViewModel = chatListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView
    
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
        
        cell.setup()
        
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

        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate(
            [
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}
