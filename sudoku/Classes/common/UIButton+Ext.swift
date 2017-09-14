//
//  UIButton+Ext.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

extension UIButton {
    func applyBoxStyle() {
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.KeyFont(size: 16)
        setTitleColor(.lightGray, for: .normal)
        setTitleColor(.darkGray, for: .selected)
        setTitleColor(.white, for: .disabled)
        setBackgroundColor(.white, forState: .normal)
        setBackgroundColor(.white, forState: .selected)
        setBackgroundColor(UIColor.keyColorWithAlpha07(), forState: .disabled)
    }
    
    func toggle() {
        isSelected = !isSelected
        if !isSelected {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        } else {
            layer.borderWidth = 2
            layer.borderColor = UIColor.keyColorWithAlpha07().cgColor
        }
    }
    
    func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
