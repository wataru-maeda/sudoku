//
//  SudokuView.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

class SudokuView: UIView {
    var finishGameCallback: ()->() = {_ in}
    
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
    func startGame() {
        for view in subviews { view.removeFromSuperview() }
        SudokuService.shared.initQ { (q) in
            self.createBoxs(rect: self.frame, question: q)
            self.createSeparaters(rect: self.frame)
        }
    }
    
    func restartGame() {
        for view in subviews { view.removeFromSuperview() }
        SudokuService.shared.initQA { (q) in
            self.createBoxs(rect: self.frame, question: q)
            self.createSeparaters(rect: self.frame)
        }
    }
    
    fileprivate func initView() {
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createSeparaters(rect: rect)
    }
    
    private func createBoxs(rect: CGRect, question: D2) {
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
                let val = question[c][r]
                if val != 0 {
                    boxButton.setTitle("\(val)", for: .normal)
                    boxButton.isEnabled = false
                }
                boxButton.tag = c * 9 + r
                boxButton.applyBoxStyle()
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
                UIColor.keyColor() : UIColor.lightGrayWithAlpha03()
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
                UIColor.keyColor() : UIColor.lightGrayWithAlpha03()
            self.addSubview(lineView)
        }
    }
}

// MARK: - Action

extension SudokuView {
    func selectBox(_ box: UIButton) {
        if let selectedBox = getSelectedBox() {
            // skip if the box is same with previous one
            if selectedBox.tag == box.tag { return }
        }
        deselectBox()
        box.toggle()
        box.bounce()
    }
    
    func clickedInputDigit(digit: Int) {
        if let selectedBox = getSelectedBox() {
            selectedBox.setTitle("\(digit)", for: .normal)
            let idx = SudokuService.convertTo2DIdx(idx: selectedBox.tag)  // convert to (c,r)
            SudokuService.shared.setQ(val: 0, c: idx.0, r: idx.1)
            SudokuService.shared.isPossible(digit: digit, c: idx.0, r: idx.1) ?
                selectedBox.bounce() : selectedBox.shake()
            SudokuService.shared.setQ(val: digit, c: idx.0, r: idx.1)
            SudokuService.shared.setProcess()
            finishGameIfCompleted()
        }
    }
    
    func clickErase(index: Int) {
        if let selectedBox = getSelectedBox() {
            let idx = SudokuService.convertTo2DIdx(idx: selectedBox.tag)  // convert to (c,r)
            SudokuService.shared.setQ(val: 0, c: idx.0, r: idx.1)
            selectedBox.setTitle("", for: .normal)
            selectedBox.bounce()
            SudokuService.shared.setProcess()
        }
    }
    
    func clickCheat() {
        if let cheat = SudokuService.shared.getCheat() {
            let idx = SudokuService.convertTo1DIdx(c: cheat.1, r: cheat.2)
            if let cheatButton = idx == 0 ?
                getZeroTagBox() :
                viewWithTag(idx) as? UIButton {
                cheatButton.setTitle("\(cheat.0)", for: .normal)
                SudokuService.shared.setQ(val: cheat.0, c: cheat.1, r: cheat.2)
                cheatButton.isSelected = false
                cheatButton.isEnabled = false
                cheatButton.bounce()
                finishGameIfCompleted()
            } else {
                clickCheat()
            }
        }
    }
    
    func clickUndo() {
        if let last = SudokuService.shared.getLastProcess() {
            for view in subviews {
                if let button = view as? UIButton {
                    if button.isEnabled {
                        let idx = SudokuService.convertTo2DIdx(idx: button.tag)
                        let val = last[idx.0][idx.1]
                        button.setTitle(val == 0 ? "" : "\(val)", for: .normal)
                    }
                }
            }
        }
    }
}

// MARK: - Animation

extension SudokuView {
    fileprivate func finishGameIfCompleted() {
        if SudokuService.shared.didComplete() {
            TimerUtil.shared.stop()
            var buttons = [UIButton]()
            for view in subviews {
                if let button = view as? UIButton {
                    buttons.append(button)
                }
            }
            showCompletionAnimation(buttons: buttons)
        }
    }
    
    private func showCompletionAnimation(buttons: [UIButton]) {
        if let button = buttons.first {
            button.isEnabled = false
            button.fadein {
                button.bounce()
                var btns = buttons
                btns.removeFirst()
                self.showCompletionAnimation(buttons: btns)
            }
        } else {
            finishGameCallback()
        }
    }
}


// MARK: - Supporting function

extension SudokuView {
    fileprivate func getZeroTagBox() -> UIButton? {
        for view in subviews {
            if let button = view as? UIButton {
                if button.tag == 0 {
                    return button
                }
            }
        }
        return nil
    }
    
    fileprivate func getSelectedBox() -> UIButton? {
        for view in subviews {
            if let button = view as? UIButton {
                if button.isSelected {
                    return button
                }
            }
        }
        return nil
    }
    
    fileprivate func deselectBox() {
        for view in subviews {
            if let button = view as? UIButton {
                if button.isSelected {
                    button.toggle()
                    break
                }
            }
        }
    }
}
