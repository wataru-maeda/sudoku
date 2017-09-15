//
//  SudokuService.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

public enum SudokuLevel {
    case Easy, Normal, Hard
}

typealias D2 = Array<Array<Int>>
typealias GetQ = ((_ q: D2) -> Void)?

class SudokuService {
    static var shared = SudokuService()
    private init() {}
    
    fileprivate var answer = D2()
    fileprivate var question = D2()
    fileprivate var monitoring = [D2]()
    fileprivate var level = SudokuLevel.Easy
}

// MARK: - Getter, Setter

extension SudokuService {
    func initA(callback: ()->()) {
        setAnswer()
        callback()
    }
    
    func initQ(callback: GetQ) {
        startProcess()
        setQuestion()
        callback?(question)
    }
    
    func initQA(callback: GetQ) {
        startProcess()
        setAnswer()
        setQuestion()
        callback?(question)
    }
    
    func get2DQ() -> D2 {
        return question
    }
    
    func get2DA() -> D2 {
        return answer
    }
    
    func getA(c: Int, r: Int) -> Int {
        return answer[c][r]
    }
    
    func setQ(val: Int, c: Int, r: Int) {
        question[c][r] = val
    }
}

// MARK: - Undo

extension SudokuService {
    fileprivate func startProcess() {
        monitoring = [get2D()]
    }
    
    internal func setProcess() {
        monitoring.append(question)
    }
    
    internal func getLastProcess() -> D2? {
        if monitoring.count <= 1 { return nil }
        monitoring.removeLast()
        question = monitoring.last ?? get2D()
        return question
    }
}

// MARK: - Cheating

extension SudokuService {
    internal func getCheat() -> (Int, Int, Int)? {
        var cr = [(Int, Int, Int)]()
        for c in 0...8 {
            for r in 0...8 {
                if question[c][r] == 0 {
                    cr.append((answer[c][r], c, r))
                }
            }
        }
        return cr.shuffled().first ?? nil
    }
}

// MARK: - Question

extension SudokuService {
    fileprivate func setQuestion() {
        question = get2D()
        var range = Int(arc4random_uniform(20))
        if level == .Easy {
            range += 30
        } else if level == .Normal {
            range += 20
        } else {
            range += 0
        }
        for _ in 0..<range {
            let c = Int(arc4random_uniform(9))
            let r = Int(arc4random_uniform(9))
            question[c][r] = answer[c][r]
        }
        print("\nQuestion is ..")
        for q in question { print(q) }
        print("\nAnswer is ..")
        for a in answer { print(a) }
    }
    
    func setLevel(level: SudokuLevel) {
        self.level = level
    }
}

// MARK: - Answer

extension SudokuService {
    fileprivate func setAnswer() {
        answer = get2D()
        for c in 0..<9 {
            for r in 0..<9 {
                guard let val = getValue(c: c, r: r) else { break }
                answer[c][r] = val
            }
        }
        
        if isZeroExists() {
            setAnswer()
            return
        }
    }
    
    private func getValue(c: Int, r: Int) -> Int? {
        let rowFilled = getRowFilled(d2: answer, c: c)
        let colFilled = getColFilled(d2: answer, r: r)
        let blockFilled = getBlockFilled(d2: answer, c: c, r: r)
        let filled = Array(Set(rowFilled + colFilled + blockFilled))
        let vals = removeFromRange(filled: filled)
        return vals.first
    }
    
    private func getRowFilled(d2: D2, c: Int) -> [Int] {
        var filled = [Int]()
        for i in 0..<d2[c].count {
            let val = d2[c][i]
            filled.append(val)
        }
        return filled
    }
    
    private func getColFilled(d2: D2, r: Int) -> [Int] {
        var filled = [Int]()
        for i in 0..<d2.count {
            let val = d2[i][r]
            filled.append(val)
        }
        return filled
    }
    
    private func getBlockFilled(d2: D2, c: Int, r: Int) -> [Int] {
        var filled = [Int]()
        var cRange = [Int]()
        var rRange = [Int]()
        let bRange = [[0,1,2],[3,4,5],[6,7,8]]
        for range in bRange {
            if range.contains(c) {
                cRange = range
            }
            if range.contains(r) {
                rRange = range
            }
        }
        for c in cRange {
            for r in rRange {
                filled.append(d2[c][r])
            }
        }
        return filled
    }
    
    private func isZeroExists() -> Bool {
        for a in answer {
            if a.contains(0) { return true }
        }
        return false
    }
    
    internal func isPossible(digit: Int, c: Int, r: Int) -> Bool {
        let rowFilled = getRowFilled(d2: question, c: c)
        let colFilled = getColFilled(d2: question, r: r)
        let blockFilled = getBlockFilled(d2: question, c: c, r: r)
        let filled = Array(Set(rowFilled + colFilled + blockFilled))
        let vals = removeFromRange(filled: filled)
        return vals.contains(digit)
    }
}

// MARK: - Supporting Functions

extension SudokuService {
    fileprivate func get2D() -> D2 {
        return [
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0],
            [0, 0, 0,  0, 0, 0,  0, 0, 0]
        ]
    }
    
    fileprivate func convert1D(d2: D2) -> [Int]{
        var d1 = [Int]()
        for row in d2 {
            for val in row {
                d1.append(val)
            }
        }
        return d1
    }
    
    class func convertTo2DIdx(idx: Int) -> (Int, Int) {
        let c = Int(floor(CGFloat(idx / 9)))
        let r = Int(idx - 9 * c)
        return (c, r)
    }
    
    class func convertTo1DIdx(c: Int, r: Int) -> Int {
        return 9 * c + r
    }
    
    fileprivate func removeFromRange(filled: [Int]) -> [Int]{
        var range = [1,2,3,4,5,6,7,8,9]
        for val in filled {
            if range.contains(val) {
                range = range.filter { $0 != val }
            }
        }
        return range.shuffled()
    }
    
    func didComplete() -> Bool {
        for c in 0...8 {
            for r in 0...8 {
                if question[c][r] == 0 {
                    return false
                } else if answer[c][r] != question[c][r] {
                    return false
                }
            }
        }
        return true
    }
}
