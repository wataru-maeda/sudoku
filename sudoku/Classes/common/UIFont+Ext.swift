//
//  UIFont+Ext.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

extension UIFont {
    class func KeyFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Futura-CondensedMedium", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
    }
    
    class func KeyBoldFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Futura-CondensedExtraBold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
    }
}
