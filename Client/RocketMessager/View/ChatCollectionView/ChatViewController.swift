//
//  ChatViewController.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 04.04.24.
//

import UIKit

// FIXME: Extract to file
class RMTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
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
    
    private let viewModel: ChatViewModelProtocol
    
    private var layout = CollectionViewBuilder.buildCollectionViewLayout()
    
    private lazy var inputTextField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Config.Colors.inputTextFieldBackgroundColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 13.0
        textField.delegate = self
        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private var inputButton: UIButton = {
        let button = UIButton()
        button.setImage(.chatSendButton, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Initializer
    
    init(viewModel: ChatViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let text = inputTextField.text else {
            fatalError("Input text field is empty")
        }
        let model = MessageModel(
            text: text,
            senderName: "Billy",
            sendDate: Date(),
            type: .currentUser,
            isLastMessage: true
        )
        viewModel.sendMessage(model)
        inputTextField.text = nil
        collectionView.performBatchUpdates { [weak self] in
            let indexPath = IndexPath(row: self?.viewModel.messages.count ?? 0, section: 0)
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    private func animateInputChatButton(_ isShowing: Bool) {
        //FIXME: add animation
        inputButton.isHidden = !isShowing
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.isEmpty == true {
            animateInputChatButton(false)
        } else {
            animateInputChatButton(true)
        }
    }
}

/*
 How to integrate Combine with
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
 */

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ChatViewCollectionViewCell = collectionView.dequeue(for: indexPath) else {
            return UICollectionViewCell()
        }
        let model = viewModel.messages[indexPath.row]
        cell.setModel(model)
        return cell
    }
}
