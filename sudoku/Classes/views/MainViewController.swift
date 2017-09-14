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
            sudokuView.finishGameCallback = {
                self.showSubview(type: .Result)
            }
        }
    }
    fileprivate lazy var overlayView: UIView = {
        let overlay = UIView()
        overlay.frame = self.view.bounds
        overlay.backgroundColor = UIColor.lightGrayWithAlpha03()
        overlay.isHidden = true
        overlay.alpha = 0
        return overlay
    }()
    
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
        showSubview(type: .Option)
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

// MARK: - Subviews

extension MainViewController {
    fileprivate func showSubview(type: SubviewType) {
        overlayView.removeFromSuperview()
        overlayView.isHidden = false
        var subview: UIView?
        let width = view.frame.size.width - 60
        if type == .Option {
            subview = getOptionView(width: width)
        } else if type == .Pause {
            subview = getPauseView(width: width)
        } else {
            subview = getResultView(width: width)
        }
        subview?.alpha = 0
        view.addSubview(overlayView)
        view.addSubview(subview!)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            subview?.alpha = 1
            subview?.center = self.view.center
            self.overlayView.alpha = 1
        }, completion: nil)
    }
    
    private func getOptionView(width: CGFloat) -> OptionView {
        let optionView = OptionView.getView(newWidth: width)
        optionView.dismissBlock = {
            self.dismissSubview(subview: optionView)
            self.sudokuView.startGame()
        }
        SudokuService.shared.initA {
            optionView.playButton.isEnabled = true
        }
        return optionView
    }
    
    private func getPauseView(width: CGFloat) -> PauseView {
        let pauseView = PauseView.getView(newWidth: width)
        pauseView.restartBlock = {
            self.sudokuView.restartGame()
            self.dismissSubview(subview: pauseView)
        }
        pauseView.dismissBlock = {
            self.dismissSubview(subview: pauseView)
        }
        return pauseView
    }
    
    private func getResultView(width: CGFloat) -> ResultView {
        let resultView = ResultView.getView(newWidth: width)
        resultView.dismissBlock = {
            self.dismissSubview(subview: resultView)
        }
        return resultView
    }
    
    private func dismissSubview(subview: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            subview.alpha = 0
            self.overlayView.alpha = 0
        }, completion: { finished in
            subview.removeFromSuperview()
            self.overlayView.isHidden = true
            self.overlayView.removeFromSuperview()
        })
        
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
        sudokuView.clickUndo()
    }
    
    @IBAction func clickTimerPlay(_ sender: UIButton) {
        sender.bounce()
    }
    
    @IBAction func clickTimerStop(_ sender: UIButton) {
        sender.bounce()
        showSubview(type: .Pause)
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
