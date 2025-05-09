//
//  ChatCoordinator.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 05.05.25.
//

import UIKit

protocol ChatCoordinatorProtocol: AnyObject {
    func coordinateToChatList(name: String)
}

final class ChatCoordinator: ChatCoordinatorProtocol {
    
    private weak var navigationController: UINavigationController!
    private var socketManager: RMSocketManagerProtocol
    
    init(navigationController: UINavigationController, socketManager: RMSocketManagerProtocol) {
        self.navigationController = navigationController
        self.socketManager = socketManager
    }
    
    func coordinateToChatList(name: String) {
        let chatListBuildData: ChatListBuildData = ChatListBuildData(
            nickName: name,
            // TODO: Dependency Injection
            socketManager: socketManager,
            coordinator: self
        )
        let chatListBuilder: ChatListBuilder = ChatListBuilder()
        let chatListViewController = chatListBuilder.build(chatListBuildData as BuildData)
        navigationController.pushViewController(chatListViewController, animated: true)
    }
    
    struct ChatInfo {
        var chatId: String
        var chatName: String
    }
    
    func coordinateToChat(chatInfo: ChatInfo) {
        // do nothing
    }
}
