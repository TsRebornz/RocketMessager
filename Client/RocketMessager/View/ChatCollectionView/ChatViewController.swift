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
    let isLastMessage: Bool
}

protocol MessageBuilder {
    func build() -> [MessageModel]
}

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

final class ChatViewController: UIViewController {
    
    enum Config {
        enum Layout {
            static let horizontalInset = 24.0
        }
    }
    
    private let messageBuilder: MessageBuilder = TestMessageBuilder()
    private lazy var messages: [MessageModel] = messageBuilder.build()
    
    private var layout = CollectionViewBuilder.buildCollectionViewLayout()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        setupLayout()
        // FIXME: Extract to design system colors
        view.backgroundColor = .systemBackground
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        
    }
        
    // MARK: - Public
    
    // MARK: - Private
    
    // MARK: - Private methods
    
    private func setupLayout() {
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(cell: ChatViewCollectionViewCell.self)
        collectionView.dataSource = self
        view.addSubview(collectionView)
                        
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.Layout.horizontalInset),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Config.Layout.horizontalInset),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
        
        let viewBackground = UIView()
        view.addSubview(viewBackground)
        viewBackground.translatesAutoresizingMaskIntoConstraints = false
        
        let inputTextField = UITextField()
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = "Type a message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [inputTextField])
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        viewBackground.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [
                viewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.Layout.horizontalInset),
                viewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Config.Layout.horizontalInset),
                viewBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: viewBackground.topAnchor),
                stackView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: viewBackground.bottomAnchor),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
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
