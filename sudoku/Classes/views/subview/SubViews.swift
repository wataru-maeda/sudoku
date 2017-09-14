//
//  SubViews.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/14.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

// MARK: - Option

class OptionView: UIView {
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
    
    @IBAction func play(_ sender: UIButton) {
    }
}

// MARK: - Pause

class PauseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
    }
    
    @IBAction func resume(_ sender: UIButton) {
    }
}

// MARK: - Good Job

class GoodJobView: UIView {
    @IBOutlet var timerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
    }
}
