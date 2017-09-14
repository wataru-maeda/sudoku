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
        if type == .Option {
            subview = getOptionView()
        } else if type == .Pause {
            subview = getPauseView()
        } else {
            subview = getResultView()
        }
        subview?.alpha = 0
        view.addSubview(overlayView)
        view.addSubview(subview!)
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, animations: {
                subview?.alpha = 1
                subview?.center = self.view.center
            })
        })
    }
    
    private func getOptionView() -> OptionView {
        let optionView = OptionView.getView(
            newWidth: view.frame.size.width - 60
        )
        optionView.dismissBlock = {
            UIView.animate(withDuration: 0.3, animations: {
                optionView.alpha = 0
                self.overlayView.alpha = 0
            }, completion: { finished in
                optionView.removeFromSuperview()
                self.overlayView.isHidden = true
                self.overlayView.removeFromSuperview()
            })
        }
        return optionView
    }
    
    private func getPauseView() -> PauseView {
        let pauseView = PauseView.getView(
            newWidth: view.frame.size.width - 60
        )
        pauseView.dismissBlock = {
            UIView.animate(withDuration: 0.3, animations: {
                pauseView.alpha = 0
                self.overlayView.alpha = 0
            }, completion: { finished in
                pauseView.removeFromSuperview()
                self.overlayView.isHidden = true
                self.overlayView.removeFromSuperview()
            })
        }
        return pauseView
    }
    
    private func getResultView() -> ResultView {
        let resultView = ResultView.getView(
            newWidth: view.frame.size.width - 60
        )
        resultView.dismissBlock = {
            UIView.animate(withDuration: 0.3, animations: {
                resultView.alpha = 0
                self.overlayView.alpha = 0
            }, completion: { finished in
                resultView.removeFromSuperview()
                self.overlayView.isHidden = true
                self.overlayView.removeFromSuperview()
            })
        }
        return resultView
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
