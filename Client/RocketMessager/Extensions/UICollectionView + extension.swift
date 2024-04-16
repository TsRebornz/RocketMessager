//
//  UICollectionView + extension.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 16.04.24.
//

import UIKit

///
/// Allow you to register cells with code
///     <CellName>.reuseIdentifier
extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    ///
    /// Coupled with extension above you could register UICollectionViewCell like this
    ///     collectionView.register(cell: <CellName>.self)
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    ///
    /// Could dequeue UICollectionViewCell easier
    ///     collectionView.register(cell: <CellName>.self)
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        // FIXME: Forceunwrap
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
}
