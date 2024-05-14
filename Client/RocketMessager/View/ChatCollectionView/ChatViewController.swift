//
//  ChatViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 04.04.24.
//

import UIKit

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
}

protocol MessageBuilder {
    func build() -> [MessageModel]
}

// MARK: - Test
final class TestMessageBuilder: MessageBuilder {
    func build() -> [MessageModel] {
        return [
            .init(text: "t1", senderName: "s1", sendDate: Date.now, type: .other),
            .init(text: "t2", senderName: "s2", sendDate: Date.now, type: .currentUser),
            .init(text: "t3", senderName: "s3", sendDate: Date.now, type: .other)
        ]
    }
}

extension ChatViewController: ChatCollectionViewLayoutDelegate {
    
    func alignmentForCell(_ indexPath: IndexPath) -> ChatCollectionViewLayoutAlignment {
        let message = messages[indexPath.row]
        return message.type.chatLayoutType
    }
    
    func contentSizeFotItem(_ item: IndexPath) -> CGSize {
        // TODO: Need precalculate cell size
        return .init(width: 100, height: 30)        
    }
}

final class ChatViewController: UIViewController {
    
    private let messageBuilder: MessageBuilder = TestMessageBuilder()
    private lazy var messages: [MessageModel] = messageBuilder.build()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - Private methods
    
    private func setupLayout() {
        // FIXME: - Extract UICollectionView building
        let layout = ChatCollectionViewLayout()
        layout.delegate = self
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cell: ChatViewCollectionViewCell.self)
        collectionView.dataSource = self
        view.addSubview(collectionView)
                        
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ChatViewCollectionViewCell = collectionView.dequeue(for: indexPath) else {
            return UICollectionViewCell()
        }
        let model = messages[indexPath.row]
        cell.setModel(model)
        return cell
    }
}
