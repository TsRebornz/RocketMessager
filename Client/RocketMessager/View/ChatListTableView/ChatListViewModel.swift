//
//  ChatListViewModel.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 25.03.25.
//

import Foundation
import Combine

struct ChatModel {
    
}

protocol ChatListViewModelProtocol {
    var chats: [ChatModel] { get }
    func setup()
}

public final class ChatListViewModel: ObservableObject, ChatListViewModelProtocol {
    
    enum Event {
        case viewDidLoad
    }
    
    @Published var chats: [ChatModel] = []
    
    private let socketManager: RMSocketManagerProtocol
    private let nickName: String
    private var anyCancellableSet: Set<AnyCancellable> = []
    
    init(socketManager: RMSocketManagerProtocol, nickName: String) {
        self.socketManager = socketManager
        self.nickName = nickName
    }
    
    /*
     What's problem? Need to transfer nick
     */
    
    func setup() {
        socketManager.connect(nickName)
        socketManager.usersPublisher.sink { competion in
//            print(competion)
        } receiveValue: { data in
//            print(data)
        }.store(in: &anyCancellableSet)
    }
}

