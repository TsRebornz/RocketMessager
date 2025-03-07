//
//  ChatListTableViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 07.03.25.
//

import UIKit

final class ChatListTableViewCell: UITableViewCell {
    static let cellIdentifier = "ChatListTableViewCell"
}

final class ChatListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(
            ChatListTableViewCell.self,
            forCellReuseIdentifier: ChatListTableViewCell.cellIdentifier
        )
    }
    
    
}
