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

final class ChatCollectionViewLayout: UICollectionViewLayout {
    
    enum Constants {
        static let leftRightInset = 16.0
        static let cellVerticalInset = 8.0
    }
    
    let itemEdgeSize: CGFloat = 50.0
    let itemSize = CGSize(width: 50.0, height: 50.0)
    var attributesList = [UICollectionViewLayoutAttributes]()
    weak var delegate: ChatCollectionViewLayoutDelegate?
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard !attributesList.isEmpty else {
            return nil
        }
        let attributes = attributesList[indexPath.row]
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? CGSize.zero
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
    }
    
    override func prepare() {
        super.prepare()
    
        self.attributesList = []
        let _: CGFloat = 10.0
        
        guard let collectionView, let delegate else {
            return
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        var cellsYPositionsDictionary = [Int: CGFloat]()
        _ = (0..<itemsCount).reduce(CGFloat(0.0), { partialResult, itemNum in
            let indexPath = IndexPath(row: itemNum, section: 0)
            let currentLayoutHeight = Constants.cellVerticalInset + delegate.contentSizeFotItem(indexPath).height
            // FIXME: - Need to debug
            let currentLayout = partialResult + currentLayoutHeight
            cellsYPositionsDictionary[itemNum] = currentLayout
            return currentLayout
        })
        
        for i in 0..<itemsCount {
            // TODO: Allow more than one section (Date grouping)
            let section = 0
            let indexPath = IndexPath(row: i, section: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        
            attributes.size = delegate.contentSizeFotItem(indexPath)
                        
            switch delegate.alignmentForCell(indexPath) {
            case .left:
                attributes.frame.origin.x = Constants.leftRightInset
            case .right:
                attributes.frame.origin.x = collectionView.bounds.width
                    - Constants.leftRightInset
                    - delegate.contentSizeFotItem(indexPath).width
            }
            attributes.frame.origin.y = cellsYPositionsDictionary[i] ?? 0.0
            attributesList.append(attributes)
        }
    }
}
