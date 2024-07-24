//
//  CollectionViewBuilder.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 24.07.24.
//

import UIKit

class CollectionViewBuilder {
    
    static func buildCollectionViewLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(110)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(4)

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [footer]
        
        return ChatCollectionViewLayout(section: section)
    }
}
