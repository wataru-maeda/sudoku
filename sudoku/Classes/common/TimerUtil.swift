//
//  TimerUtil.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/14.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

class TimerUtil {
    static var shared = TimerUtil()
    private init() {} // Singleton
    
    var updateTimeCallback: (_ time: String) -> () = {_ in}
    
    fileprivate var timer: Timer?
    fileprivate var sec: Int = 0
}

// MARK: - Action

extension TimerUtil {
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.countup),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stop()
        sec = 0
    }
    
    func get() -> String {
        return getElapsedTime(second: sec)
    }
    
    @objc func countup() {
        sec += 1
        let timeString = getElapsedTime(second: sec)
        updateTimeCallback(timeString)
    }
}

// MARK: - Supporting functions

extension TimerUtil {
    fileprivate func getElapsedTime(second: Int) -> String {
        // Second
        if second / 60 < 1 {
            return "\(NSString(format: "00:00:%02d", second))"
        }
        // Hour
        else if second / (60 * 60) >= 1 {
            
            let h = Int(second / (60 * 60))
            let min = Int((second - (h * 60 * 60)) / 60)
            let sec = second - Int(h * 60 * 60) - Int(min * 60)
            return "\(NSString(format: "%02d", Int(h))):\(NSString(format: "%02d", Int(min))):\(NSString(format: "%02d", Int(sec)))"
        // Min
        } else {
            let min = Int(second / 60)
            let sec = second - Int(min * 60)
            return "\(NSString(format: "%02d", Int(min))):\(NSString(format: "%02d", Int(sec)))"
        }
    }
}
