//
//  MainViewController.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/12.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var menuView: UIView!
    @IBOutlet var inputDigitView: UIView!
    @IBOutlet var sudokuView: SudokuView! {
        didSet {
            sudokuView.layer.cornerRadius = 5
            sudokuView.clipsToBounds = true
            sudokuView.dropShadow()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initActions()
    }
}

// MARK: - UI

extension MainViewController {
    fileprivate func initViews() {
        roundButton()
    }
    
    private func roundButton() {
        for view in menuView.subviews {
            if let button = view as? UIButton {
                button.layer.cornerRadius = 5
                button.imageView?.contentMode = .scaleAspectFit
            }
        }
        for view in inputDigitView.subviews {
            if let button = view as? UIButton {
                button.layer.borderWidth = 3
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.lightGrayWithAlpha03().cgColor
            }
        }
    }
}

// MARK: - Action

extension MainViewController {
    fileprivate func initActions() {
        for view in inputDigitView.subviews {
            if let button = view as? UIButton {
                button.addTarget(
                    self,
                    action: #selector(self.clickDigit(_:)),
                    for: .touchUpInside
                )
            }
        }
    }
    
    func clickDigit(_ sender: UIButton) {
        sender.bounce()
        guard let digit = Int(sender.titleLabel?.text ?? "") else { return }
        sudokuView.clickedInputDigit(digit: digit)
    }
    
    @IBAction func clickCheat(_ sender: UIButton) {
        sender.bounce()
        sudokuView.clickCheat()
    }
    
    @IBAction func clickErase(_ sender: UIButton) {
        sender.bounce()
        sudokuView.clickErase(index: sender.tag)
    }
    
    @IBAction func clickUndo(_ sender: UIButton) {
        sender.bounce()
    }
    
    @IBAction func clickTimerPlay(_ sender: UIButton) {
        sender.bounce()
    }
    
    @IBAction func clickTimerStop(_ sender: UIButton) {
        sender.bounce()
    }
}

// MARK: - Supporting functions

extension MainViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
