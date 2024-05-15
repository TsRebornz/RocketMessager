//
//  ChatViewCollectionViewCell.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 14.05.24.
//

import UIKit

// FIXME: - Extract to proper place
extension UIFont {
    func stringOfSize(string: String, maxWidth: CGFloat) -> CGSize {
        let string = NSString(string: string).boundingRect(
            with: .init(width: maxWidth, height: .greatestFiniteMagnitude),
            // TODO: What parameter is better?
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self],
            context: nil
        )
        return string.size
    }
}

final class ChatViewCollectionViewCell: UICollectionViewCell {
    
    enum Constatnts {
        static let font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    let textLabel = UILabel()
    
    override var intrinsicContentSize: CGSize {
        guard let text = textLabel.text else {
            return super.intrinsicContentSize
        }
        let maxCellWidth = UIScreen.main.bounds.width / 2
        let size = textLabel.font.stringOfSize(string: text, maxWidth: maxCellWidth)
        textLabel.sizeToFit()
        return textLabel.font.stringOfSize(string: text, maxWidth: maxCellWidth)
    }
    
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
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .yellow
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate(
            [
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
    }
}
