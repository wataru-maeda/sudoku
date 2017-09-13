//
//  SudokuView.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

class SudokuView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
}

// MARK: - UI

extension SudokuView {
    fileprivate func initView() {
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createBoxs(rect: rect)
        createSeparaters(rect: rect)
    }
    
    private func createBoxs(rect: CGRect) {
        let boardLength = rect.size.width
        let boxLength = boardLength / 9
        for c in 0...8 {
            for r in 0...8 {
                let boxButton = UIButton(frame: CGRect(
                    x: CGFloat(r) * boxLength,
                    y: CGFloat(c) * boxLength,
                    width: boxLength,
                    height: boxLength)
                )
                boxButton.setTitle("\(c * 9 + r)", for: .normal)
                boxButton.setTitleColor(.darkGray, for: .normal)
                boxButton.tag = c * 9 + r
                boxButton.addTarget(self, action: #selector(self.selectBox(_:)), for: .touchUpInside)
                self.addSubview(boxButton)
            }
        }
    }
    
    private func createSeparaters(rect: CGRect) {
        let boardLength = rect.size.width
        let boxLength = boardLength / 9
        for r in 1...9 {
            let lineView = UIView(frame: CGRect(
                x: CGFloat(r) * boxLength,
                y: 0,
                width: 1,
                height: boardLength)
            )
            lineView.backgroundColor = r % 3 == 0 ?
                .lightGray : UIColor.lightGrayWithAlpha03()
            self.addSubview(lineView)
        }
        for c in 1...9 {
            let lineView = UIView(frame: CGRect(
                x: 0,
                y: CGFloat(c) * boxLength,
                width: boardLength,
                height: 1)
            )
            lineView.backgroundColor = c % 3 == 0 ?
                .lightGray : UIColor.lightGrayWithAlpha03()
            self.addSubview(lineView)
        }
    }
}

// MARK: - Action

extension SudokuView {
    func selectBox(_ box: UIButton) {
        print(box.tag)
    }
}
