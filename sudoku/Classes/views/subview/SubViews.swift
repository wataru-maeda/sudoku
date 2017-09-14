//
//  SubViews.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/14.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

public enum SubviewType {
    case Option, Pause, Result
}

// MARK: - Option

class OptionView: UIView {
    var dismissBlock: ()->() = {_ in}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    @IBAction func changeLevel(_ sender: UISegmentedControl) {
    }
    
    @IBAction func play() {
        dismissBlock()
    }
    
    class func getView(newWidth: CGFloat) -> OptionView {
        let nib = UINib(nibName: "subview", bundle: nil)
        let optView = nib.instantiate(withOwner: self, options: nil).first as! OptionView
        var frame = optView.frame
        frame.origin.x = 30
        frame.origin.y = UIScreen.main.bounds.height
        frame.size.width = newWidth
        optView.frame = frame
        return optView
    }
}

// MARK: - Pause

class PauseView: UIView {
    var dismissBlock: ()->() = {_ in}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    @IBAction func startNewGame() {
        dismissBlock()
    }
    
    @IBAction func resume() {
        dismissBlock()
    }
    
    class func getView(newWidth: CGFloat) -> PauseView {
        let nib = UINib(nibName: "subview", bundle: nil)
        let pauseView = nib.instantiate(withOwner: self, options: nil)[1] as! PauseView
        var frame = pauseView.frame
        frame.origin.x = 30
        frame.origin.y = UIScreen.main.bounds.height
        frame.size.width = newWidth
        pauseView.frame = frame
        return pauseView
    }
}

// MARK: - Result

class ResultView: UIView {
    var dismissBlock: ()->() = {_ in}
    @IBOutlet var timerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    @IBAction func dismiss() {
        dismissBlock()
    }
    
    class func getView(newWidth: CGFloat) -> ResultView {
        let nib = UINib(nibName: "subview", bundle: nil)
        let resultView = nib.instantiate(withOwner: self, options: nil)[2] as! ResultView
        var frame = resultView.frame
        frame.origin.x = 30
        frame.origin.y = UIScreen.main.bounds.height
        frame.size.width = newWidth
        resultView.frame = frame
        return resultView
    }
}
