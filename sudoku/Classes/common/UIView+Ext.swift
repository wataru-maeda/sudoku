//
//  UIView+Ext.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.borderWidth = 1
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.borderColor = UIColor.KeyLightColor().cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func bounce() {
        let forward = CATransform3DMakeScale(1.1, 1.1, 1)
        let back = CATransform3DMakeScale(0.9, 0.9, 1)
        let forward2 = CATransform3DMakeScale(1, 1, 1)
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform")
        bounceAnimation.values = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: forward),
            NSValue(caTransform3D: back),
            NSValue(caTransform3D: forward2)
        ]
        bounceAnimation.keyTimes = [0, 0.3, 0.6, 1]
        bounceAnimation.duration = 0.3
        layer.add(bounceAnimation, forKey: "transform")
    }
}
