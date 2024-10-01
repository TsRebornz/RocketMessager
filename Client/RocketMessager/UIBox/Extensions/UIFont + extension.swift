//
//  UIFont + extension.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 15.05.24.
//

import UIKit

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
