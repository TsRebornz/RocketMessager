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
    
    init(socketManager: RMSocketManagerProtocol) {
        self.socketManager = socketManager
    }
}

