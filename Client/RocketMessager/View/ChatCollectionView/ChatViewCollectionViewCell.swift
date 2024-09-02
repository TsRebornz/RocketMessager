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
        //static let textInset
        
        enum Font {
            static let font = UIFont.preferredFont(forTextStyle: .caption1)
            
            static let userCellTextColor = DesignColors.Chat.userCellTextColor
            static let otherCellTextColor = DesignColors.Chat.otherCellTextColor
        }
        
        enum Colors {
            static let cellUserColor = DesignColors.Chat.userCellBackground
            static let cellOtherColor = DesignColors.Chat.otherCellBackground
            
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
    
    let messageLabel = UILabel()
    var backgroundMessageView = UIView()
    let timesendLabel = UILabel()
    //var backgroundTimesendView = UIView()
    var backgroundCellView = UIView()
        
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
        messageLabel.font = Config.Font.font
        messageLabel.text = model.text
        timesendLabel.text = "09:25"
        switch model.type {
        case .currentUser:
            layout = .trailing
            //textLabel.textAlignment = .right
            messageLabel.textColor = Config.Font.userCellTextColor
            backgroundMessageView.backgroundColor = Config.Colors.cellUserColor
        case .other:
            layout = .leading
            //textLabel.textAlignment = .left
            messageLabel.textColor = Config.Font.otherCellTextColor
            backgroundMessageView.backgroundColor = Config.Colors.cellOtherColor
        }
        
        setupBorderBindLayout()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Config
    
    private func configure() {
        backgroundMessageView.layer.masksToBounds = true
        backgroundMessageView.layer.cornerRadius = Config.cornerRadius
        messageLabel.numberOfLines = 0
        timesendLabel.textAlignment = .right
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
        
        //F2F7FB
        
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        backgroundMessageView.translatesAutoresizingMaskIntoConstraints = false
        timesendLabel.translatesAutoresizingMaskIntoConstraints = false
        //backgroundTimesendView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backgroundCellView)
        backgroundCellView.addSubview(backgroundMessageView)
        backgroundCellView.addSubview(timesendLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundMessageView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate(
            [
                
                backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
                backgroundCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                backgroundCellView.widthAnchor.constraint(
                    equalTo: contentView.widthAnchor,
                    // FIXME: - Extract to constants
                    multiplier: 0.65
                ),
                backgroundMessageView.topAnchor.constraint(
                    equalTo: backgroundCellView.topAnchor, constant: Config.messageLabelInset.top
                ),
                backgroundMessageView.bottomAnchor.constraint(
                    equalTo: timesendLabel.topAnchor, constant: -Config.messageViewBottomInset
                ),
                backgroundMessageView.leftAnchor.constraint(
                    equalTo: backgroundCellView.leftAnchor, constant: Config.messageLabelInset.left
                ),
                backgroundMessageView.rightAnchor.constraint(
                    equalTo: backgroundCellView.rightAnchor, constant: Config.messageLabelInset.left
                ),
                ///
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
                ),
                ///
                timesendLabel.leftAnchor.constraint(
                    equalTo: backgroundCellView.leftAnchor, constant: Config.messageLabelInset.left
                ),
                timesendLabel.rightAnchor.constraint(
                    equalTo: backgroundCellView.rightAnchor, constant: Config.messageLabelInset.left
                ),
                timesendLabel.bottomAnchor.constraint(
                    equalTo: backgroundCellView.bottomAnchor, constant: Config.messageViewBottomInset
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
