//
//  ChatListViewModel.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 25.03.25.
//

import Foundation

struct ChatModel {
    
}

protocol ChatListViewModelProtocol {
    var chats: [ChatModel] { get }
}

public final class ChatListViewModel: ObservableObject, ChatListViewModelProtocol {
    @Published var chats: [ChatModel] = []
    
    private let socketManager: RMSocketManagerProtocol
    private let nickName: String
    
    init(socketManager: RMSocketManagerProtocol, nickName: String) {
        self.socketManager = socketManager
        self.nickName = nickName
    }
    
    /*
     What's problem? Need to transfer nick
     */
    
    func setup() {
        socketManager.connect(nickName)
    }
}

