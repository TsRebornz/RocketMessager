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
        static let cellTextInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
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
    
    let textLabel = UILabel()
    var backgroundCellView = UIView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    func setModel(_ model: MessageModel) {
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = Config.cornerRadius
        textLabel.numberOfLines = 0
        textLabel.font = Config.Font.font
        textLabel.text = model.text
        switch model.type {
        case .currentUser:
            layout = .trailing
            //textLabel.textAlignment = .right
            textLabel.textColor = Config.Font.userCellTextColor
            backgroundCellView.backgroundColor = Config.Colors.cellUserColor
        case .other:
            layout = .leading
            //textLabel.textAlignment = .left
            textLabel.textColor = Config.Font.otherCellTextColor
            backgroundCellView.backgroundColor = Config.Colors.cellOtherColor
        }
        
        setupBorderBindLayout()
        setNeedsLayout()
        layoutIfNeeded()
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
        
        
        contentView.addSubview(backgroundCellView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.addSubview(textLabel)
        
        NSLayoutConstraint.activate(
            [
                
                backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
                backgroundCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                backgroundCellView.widthAnchor.constraint(
                    equalTo: contentView.widthAnchor,
                    // FIXME: - Extract to constants
                    multiplier: 0.65
                ),
                textLabel.topAnchor.constraint(
                    equalTo: backgroundCellView.topAnchor, constant: Config.cellTextInset.top
                ),
                textLabel.bottomAnchor.constraint(
                    equalTo: backgroundCellView.bottomAnchor, constant: -Config.cellTextInset.bottom
                ),
                textLabel.leftAnchor.constraint(
                    equalTo: backgroundCellView.leftAnchor, constant: Config.cellTextInset.left
                ),
                textLabel.rightAnchor.constraint(
                    equalTo: backgroundCellView.rightAnchor, constant: -Config.cellTextInset.right
                )
            ]
        )
        
        leadingConstraint = backgroundCellView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        )
        
        trailingConstraint = backgroundCellView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        )

        setupBorderBindLayout()
    }
}
