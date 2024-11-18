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

// FIXME: Extract to file
class RMTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
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
        
        enum Colors {
            static let inputTextFieldBackgroundColor: UIColor = DesignColors.ChatInput.inputTextFieldBackgroundColor
        }
        
        enum Constants {
            static let inputTextFieldHorizontalSpacing: CGFloat = 16.0
        }
    }
    
    private let messageBuilder: MessageBuilder = TestMessageBuilder()
    private lazy var messages: [MessageModel] = messageBuilder.build()
    
    private var layout = CollectionViewBuilder.buildCollectionViewLayout()
    
    private var inputTextField: RMTextField = {
        let textField = RMTextField()
        textField.borderStyle = .none
        textField.placeholder = "Type a message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Config.Colors.inputTextFieldBackgroundColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 13.0
        return textField
    }()
    
    private var inputButton: UIButton = {
        let button = UIButton()
        button.setImage(.chatSendButton, for: .normal)
        return button
    }()
    
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
        setupInputButton()
        
        let stackView = UIStackView(arrangedSubviews: [inputTextField, inputButton])
        stackView.spacing = Config.Constants.inputTextFieldHorizontalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        viewBackground.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [
                viewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Config.Layout.horizontalInset),
                viewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Config.Layout.horizontalInset),
                viewBackground.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: viewBackground.leadingAnchor),
                stackView.topAnchor.constraint(equalTo: viewBackground.topAnchor),
                stackView.trailingAnchor.constraint(equalTo: viewBackground.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: viewBackground.bottomAnchor),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
            ]
        )
    }
    
    private func setupInputButton() {
        inputButton.addTarget(self, action: #selector(didTapInputButton), for: .touchUpInside)
    }
    
    @objc private func didTapInputButton() {
        
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
