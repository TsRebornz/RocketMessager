//
//  Colors.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 30.08.24.
//

import UIKit

public extension UIColor {
    
    // Ala design system
    enum RM {
        static var label: UIColor {
            UIColor.white
        }
        static var secondaryLabel: UIColor {
            UIColor(hexString: "000E08")
        }
        
        static var background: UIColor {
            UIColor(hexString: "000E08")
        }
        
        static var backgroundSecondary: UIColor {
            UIColor(hexString: "000E08")
        }
        
        static var gray: UIColor {
            UIColor(hexString: "797C7B")
        }
        
        static var gray2: UIColor {
            UIColor(hexString: "797C7B")
        }
    }
}

enum DesignColors {
    enum Chat {
        static let userCellBackground = UIColor(hexString: "20A090")
        static let otherCellBackground = UIColor(hexString: "F2F7FB")
        static let userCellTextColor = UIColor.RM.label
        static let otherCellTextColor = UIColor.RM.secondaryLabel
        static let timeLabelCellTextColor = UIColor.RM.gray
    }
    
    enum ChatTitle {
        static let titleTextColor = UIColor(hexString: "000000")
        static let subtitleTextColor = UIColor.RM.gray
    }
    
    enum ChatInput {
        static let inputTextFieldBackgroundColor = UIColor(hexString: "F3F6F6")
    }
    
    enum UserList {
        static let titleTextColor = UIColor(hexString: "000000")
        static let statusTextColor = UIColor.RM.gray2
    }
}

extension UIColor {
    
}
