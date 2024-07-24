//
//  ChatViewCollectionViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 14.05.24.
//

import UIKit

final class ChatViewCollectionViewCell: UICollectionViewCell {
    
    enum Layout {
        case leading, trailing
    }
    
    enum Constatnts {
        static let font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    override var frame: CGRect {
        didSet {
            print("ChatViewCollectionViewCell did changed to \(frame)")
        }
    }
    
    private var layout: Layout = .leading
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    let textLabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: - Public
    
    func setModel(_ model: MessageModel) {
        textLabel.numberOfLines = 0
        textLabel.font = Constatnts.font
        textLabel.text = model.text
        switch model.type {
        case .currentUser:
            layout = .trailing
            textLabel.textAlignment = .right
        case .other:
            layout = .leading
            textLabel.textAlignment = .left
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
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .yellow
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate(
            [
                
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                textLabel.widthAnchor.constraint(
                    equalTo: contentView.widthAnchor,
                    // FIXME: - Extract to constants
                    multiplier: 0.65
                )
            ]
        )
        
        leadingConstraint = textLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        )
        
        trailingConstraint = textLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        )

        setupBorderBindLayout()
    }
}
