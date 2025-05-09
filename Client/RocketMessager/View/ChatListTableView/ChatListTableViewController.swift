//
//  ChatListTableViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 07.03.25.
//

import UIKit
import Combine

final class ChatListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private
    
    private let viewModel: ChatListViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(chatListViewModel: ChatListViewModelProtocol) {
        self.viewModel = chatListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListTableViewCell.cellIdentifier,
            for: indexPath
        ) as? ChatListTableViewCell,
              let chatData = viewModel.chats.enumerated().first(where: { $0.offset == indexPath.row })?.element
        else {
            return UITableViewCell()
        }
        
        cell.setup(nickName: chatData.nickName, status: chatData.id)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard 0..<viewModel.chats.count ~= indexPath.row else { return }
        let model = viewModel.chats[indexPath.row]
        viewModel.selectedChat(chatModel: model)
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        
        setupUI()
        viewModel.setup()
        subscribeToViewModelOutputs()
    }
        
    private func setupUI() {
        tableView.register(
            ChatListTableViewCell.self,
            forCellReuseIdentifier: ChatListTableViewCell.cellIdentifier
        )

        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    private func subscribeToViewModelOutputs() {
        viewModel.chatsPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // do nothing
            } receiveValue: { [tableView] _ in
                tableView.reloadData()
            }
            .store(in: &cancellable)
    }
}
