//
//  ChatViewModel.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 20.11.24.
//

import Foundation
import Combine

// MARK: - Test
final class TestMessageBuilder: MessageBuilder {
    
    func build() -> [MessageModel] {
        return [
            .init(
                text: "t1fdasfjdsaflasdjflajsdf;ljafdsafdsafsdffjdsaladfasfasfjfl;sadafasdfasfjf",
                senderName: "s1",
                sendDate: Date.now,
                type: .other,
                isLastMessage: true
            ),
            .init(
                text: "testingt2testingtestingtestingtestingtestingtestingtestingtestingtestingtesting",
                senderName: "s2",
                sendDate: Date.now,
                type: .currentUser,
                isLastMessage: false
            ),
            .init(text: "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
                  senderName: "s3",
                  sendDate: Date.now,
                  type: .other,
                  isLastMessage: false
            )
        ]
    }
}

// MARK: - Extract to model
enum MessageType {
    case currentUser
    case other
}

struct MessageModel {
    let text: String
    let senderName: String
    let sendDate: Date
    let type: MessageType
    let isLastMessage: Bool
}

protocol MessageBuilder {
    func build() -> [MessageModel]
}

protocol MessageListDataProvider {
    var nickName: String? { get set }
    func subscribe() -> AnyPublisher<[MessageModel], Error>
    func sendMessage(_ message: MessageModel)
    func isTyping() -> AnyPublisher<Bool, Error>
}

/// Create Message Model for Network layer to make them independent
/// Who must create MessageModel? ViewModel exactly

final class MessageListDataProviderImpl: MessageListDataProvider {
    private let socketManager: RMSocketManagerProtocol
        
    private var messages = [MessageModel]()
    
    private var messageCurrentValueSubject = CurrentValueSubject<[MessageModel], Error>([])
        
    private var cancellables = Set<AnyCancellable>()
    
    // FIXME: -
    var nickName: String?
    
    init(socketManager: RMSocketManagerProtocol) {
        self.socketManager = socketManager
    }
    
    func subscribe() -> AnyPublisher<[MessageModel], Error> {
        // TODO: - Added nick comparsion in future
//        guard let nickName else {
//            fatalError("nickName is nil")
//        }
        
        socketManager.chatPublisher.compactMap({ message -> MessageModel in
            guard let message else {
                fatalError("")
            }
            let messageModel = MessageModel(
                text: message.message,
                senderName: nickName,
                sendDate: Date(),
                type: .other,
                isLastMessage: false
            )
            return messageModel
        }).sink(
            receiveCompletion: { completion in },
            receiveValue: { messageModel in
                var newMessages: [MessageModel] = self.messageCurrentValueSubject.value
                newMessages.append(messageModel)
                self.messageCurrentValueSubject.send(newMessages)
            }
        ).store(in: &cancellables)
                
        return messageCurrentValueSubject.eraseToAnyPublisher()
    }
    
    func sendMessage(_ message: MessageModel) {
        socketManager.sendMessage(message.text)
    }
    
    func isTyping() -> AnyPublisher<Bool, Error> {
        return Just(false).mapError({ _ in
            Fail<Any, Error>(error: NSErrorDomain(string: "error") as! any Error) as! any Error
        }).eraseToAnyPublisher()
    }
    
}

protocol ChatViewModelProtocol {
    var messages: [MessageModel] { get }
    func sendMessage(_ message: MessageModel)
}

final class ChatViewModel: ChatViewModelProtocol {
    
    @Published var messages = [MessageModel]()
    @Published var error: Error?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let messageDataProvider: MessageListDataProvider
    
    init(messageDataProvider: MessageListDataProvider) {
        self.messageDataProvider = messageDataProvider
    }
    
    func setup() {
        messageDataProvider.subscribe()
        // FIXME: Add error handling
//            .mapError { [weak self] error in
//                self?.error = error
//            }
            .sink(receiveCompletion: { _ in
                // do nothing
            }, receiveValue: { [weak self] messages in
                self?.messages = messages
            })
            // Можно попробовать сделать просто через sink
//            .mapError({ error in
//                self.error = error
//                return
//            })
//            .values
//            .assign(to: &messages, on: .self)
            .store(in: &cancellables)
    }
    
    func sendMessage(_ message: MessageModel) {
        messageDataProvider.sendMessage(message)
    }
}
