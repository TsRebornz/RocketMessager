//
//  ChatListViewModel.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 25.03.25.
//

import Foundation
import Combine

struct ChatModel: Equatable {
    let nickName: String
    let id: String
}

protocol ChatListViewModelProtocol {
    var chats: [ChatModel] { get }
    
    var chatsPublisher: Published<[ChatModel]>.Publisher { get }
    
    var chatsPublished: Published<[ChatModel]> { get }
    
    func setup()
}

public final class ChatListViewModel: ObservableObject, ChatListViewModelProtocol {
    
    enum Event {
        case viewDidLoad
    }
    
    @Published var chats: [ChatModel] = []
    
    var chatsPublished: Published<[ChatModel]> { _chats }
    
    var chatsPublisher: Published<[ChatModel]>.Publisher { $chats }
    
    private let socketManager: RMSocketManagerProtocol
    private let nickName: String
    private var anyCancellableSet: Set<AnyCancellable> = []
    
    init(socketManager: RMSocketManagerProtocol, nickName: String) {
        self.socketManager = socketManager
        self.nickName = nickName
    }
    
    func setup() {
        socketManager.connect(nickName)
                
        socketManager.usersPublisher
            .map({ usersRaw in
                return usersRaw.map { ChatModel(nickName: $0.nickname, id: $0.id) }
            })
            .sink(receiveCompletion: { _ in
                // do nothing
            }, receiveValue: { [weak self] users in
                self?.chats = users
            })
            .store(in: &anyCancellableSet)
    }
}

