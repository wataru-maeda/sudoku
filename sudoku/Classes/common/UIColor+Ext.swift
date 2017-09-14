//
//  UIColor+Ext.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

extension UIColor {
    class func keyColor() -> UIColor {
        return UIColor(red:0.549, green:0.757, blue:0.918, alpha:1.000)
    }
    
    class func KeyLightColor() -> UIColor {
        return UIColor(red:0.976, green:0.980, blue:0.992, alpha:1.000)
    }
    
    class func keyColorWithAlpha07() -> UIColor {
        return keyColor().withAlphaComponent(0.7)
    }
    
    class func lightGrayWithAlpha03() -> UIColor {
        return UIColor.lightGray.withAlphaComponent(0.3)
    }
}
