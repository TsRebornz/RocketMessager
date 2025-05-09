//
//  ChatCoordinator.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 05.05.25.
//

import UIKit

protocol ChatCoordinatorProtocol: AnyObject {
    func coordinateToChatList(name: String)
    func coordinateToChat(chatInfo: ChatInfo)
}

struct ChatInfo {
    var chatName: String
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
        let chatListBuilder = ChatListBuilder()
        let chatListViewController = chatListBuilder.build(chatListBuildData as BuildData)
        navigationController.pushViewController(chatListViewController, animated: true)
    }
    
    func coordinateToChat(chatInfo: ChatInfo) {
        let chatBuildData = ChatBuildData(
            nickName: chatInfo.chatName,
            socketManager: socketManager
        )
        let chatBuilder = ChatBuiler()
        let chatViewController = chatBuilder.build(chatBuildData)
        navigationController.pushViewController(
            chatViewController,
            animated: true
        )
    }
}
