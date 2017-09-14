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
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func bounce() {
        let forward = CATransform3DMakeScale(1.1, 1.1, 1)
        let back = CATransform3DMakeScale(0.9, 0.9, 1)
        let forward2 = CATransform3DMakeScale(1, 1, 1)
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [
            NSValue(caTransform3D: CATransform3DIdentity),
            NSValue(caTransform3D: forward),
            NSValue(caTransform3D: back),
            NSValue(caTransform3D: forward2)
        ]
        animation.keyTimes = [0, 0.3, 0.6, 1]
        animation.duration = 0.3
        layer.add(animation, forKey: "transform")
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        layer.add(animation, forKey: "position")
    }
    
    func round(callback: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            callback()
        })
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = CGFloat(Double.pi / 180) * 360
        rotationAnimation.duration = 0.04
        rotationAnimation.repeatCount = 1
        layer.add(rotationAnimation, forKey: "rotationAnimation")
        CATransaction.commit()
    }
    
    func fadein(callback: @escaping ()->()) {
        alpha = 0
        UIView.animate(withDuration: 0.04, animations: {
            self.alpha = 1
        }, completion: { finished in
            callback()
        })
    }
}
