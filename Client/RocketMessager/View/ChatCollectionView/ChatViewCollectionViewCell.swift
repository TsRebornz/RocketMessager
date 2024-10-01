//
//  ChatViewCollectionViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 14.05.24.
//

import UIKit

final class ChatViewCollectionViewCell: UICollectionViewCell {
        
    enum Config {
        enum Layout {
            case leading, trailing
        }
        
        static let cornerRadius = 16.0
        static let messageLabelInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        static let messageViewBottomInset = 8.0
        
        enum Font {
            static let messageFont = UIFont.preferredFont(forTextStyle: .caption1)
            static let timestampFont = UIFont.preferredFont(forTextStyle: .caption2)
        }
        
        enum Colors {
            static let cellUserColor = DesignColors.Chat.userCellBackground
            static let cellOtherColor = DesignColors.Chat.otherCellBackground
            static let userCellTextColor = DesignColors.Chat.userCellTextColor
            static let otherCellTextColor = DesignColors.Chat.otherCellTextColor
            static let timeLabelCellTextColor = DesignColors.Chat.timeLabelCellTextColor
        }
    }
    
    override var frame: CGRect {
        didSet {
            print("ChatViewCollectionViewCell did changed to \(frame)")
        }
    }
    
    private var layout: Config.Layout = .leading
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    private lazy var chatStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Config.messageViewBottomInset
        return stackView
    }()
    private let messageLabel = UILabel()
    private var backgroundMessageView = UIView()
    private let timesendLabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    func setModel(_ model: MessageModel) {
        messageLabel.text = model.text
        timesendLabel.text = "09:25"
        switch model.type {
        case .currentUser:
            layout = .trailing
            messageLabel.textColor = Config.Colors.userCellTextColor
            backgroundMessageView.backgroundColor = Config.Colors.cellUserColor
        case .other:
            layout = .leading
            messageLabel.textColor = Config.Colors.otherCellTextColor
            backgroundMessageView.backgroundColor = Config.Colors.cellOtherColor
        }
        
        timesendLabel.isHidden = model.isLastMessage ? false : true
        
        setupBorderBindLayout()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Config
    
    private func configure() {
        backgroundMessageView.layer.masksToBounds = true
        backgroundMessageView.layer.cornerRadius = Config.cornerRadius
        messageLabel.numberOfLines = 0
        messageLabel.font = Config.Font.messageFont
        timesendLabel.font = Config.Font.timestampFont
        timesendLabel.textAlignment = .right
        timesendLabel.textColor = Config.Colors.timeLabelCellTextColor
    }
    
    // MARK: - Layout
    
    private func setupBorderBindLayout() {
        switch layout {
        case .leading:
            NSLayoutConstraint.deactivate([trailingConstraint]
                .compactMap{ $0 })
            NSLayoutConstraint.activate(
                [leadingConstraint].compactMap{ $0 }
            )
        case .trailing:
            NSLayoutConstraint.deactivate([leadingConstraint]
                .compactMap{ $0 })
            NSLayoutConstraint.activate(
                [trailingConstraint].compactMap{ $0 }
            )
        }
    }
    
    private func setupLayout() {
        
        chatStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundMessageView.translatesAutoresizingMaskIntoConstraints = false
        timesendLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(chatStackView)
                
        chatStackView.addArrangedSubview(backgroundMessageView)
        chatStackView.addArrangedSubview(timesendLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundMessageView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate(
            [
                
                chatStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                chatStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                chatStackView.widthAnchor.constraint(
                    equalTo: contentView.widthAnchor,
                    // FIXME: - Extract to constants
                    multiplier: 0.65
                ),
                messageLabel.topAnchor.constraint(
                    equalTo: backgroundMessageView.topAnchor, constant: Config.messageLabelInset.top
                ),
                messageLabel.bottomAnchor.constraint(
                    equalTo: backgroundMessageView.bottomAnchor, constant: -Config.messageLabelInset.bottom
                ),
                messageLabel.leftAnchor.constraint(
                    equalTo: backgroundMessageView.leftAnchor, constant: Config.messageLabelInset.left
                ),
                messageLabel.rightAnchor.constraint(
                    equalTo: backgroundMessageView.rightAnchor, constant: -Config.messageLabelInset.right
                )
            ]
        )
        
        leadingConstraint = backgroundMessageView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        )
        
        trailingConstraint = backgroundMessageView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        )

        setupBorderBindLayout()
    }
}
