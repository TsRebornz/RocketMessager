//
//  ChatViewModel.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 20.11.24.
//

import Foundation

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

protocol ChatViewModelProtocol {
    var messages: [MessageModel] { get }
    func sendMessage(_ message: MessageModel)
}

class ChatViewModel: ChatViewModelProtocol {
    private let messageBuilder: MessageBuilder = TestMessageBuilder()
    
    lazy var messages = messageBuilder.build()
    
    func sendMessage(_ message: MessageModel) {
        messages.append(message)
    }
}
