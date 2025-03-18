//
//  RMTextField.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 18.03.25.
//

import UIKit

final class RMTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 10)
    }
}
