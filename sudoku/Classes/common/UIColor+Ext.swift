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
    
    class func lightGrayWithAlpha03() -> UIColor {
        return UIColor.lightGray.withAlphaComponent(0.3)
    }
}
