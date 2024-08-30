//
//  ChatCollectionViewLayout.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 14.05.24.
//

import UIKit

enum ChatCollectionViewLayoutAlignment {
    case left, right
}

protocol ChatCollectionViewLayoutDelegate: AnyObject {
    func alignmentForCell(_ indexPath: IndexPath) -> ChatCollectionViewLayoutAlignment
    func contentSizeFotItem(_ item: IndexPath) -> CGSize
}

extension MessageType {
    var chatLayoutType: ChatCollectionViewLayoutAlignment {
        switch self {
        case .currentUser:
            .right
        case .other:
            .left
        }
    }
}

final class ChatCollectionViewLayout: UICollectionViewCompositionalLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}
