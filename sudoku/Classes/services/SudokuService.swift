//
//  SudokuService.swift
//  sudoku
//
//  Created by Wataru Maeda on 2017/09/13.
//  Copyright © 2017 Wataru Maeda. All rights reserved.
//

import UIKit

typealias D2 = Array<Array<Int>>

class SudokuService {
    static var shared = SudokuService()
    private init() {
        setAnswer()
        setQuestion()
    }
    fileprivate var answer = D2()
    fileprivate var question = D2()
}

// MARK: - Question

extension SudokuService {
    
}

// MARK: - Question

extension SudokuService {
    fileprivate func setQuestion() {
        question = get2D()
        let range = Int(arc4random_uniform(20)) + 20
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
        let rowFilled = getRowFilled(c: c)
        let colFilled = getColFilled(r: r)
        let blockFilled = getBlockFilled(c: c, r: r)
        let filled = Array(Set(rowFilled + colFilled + blockFilled))
        let vals = removeFromRange(filled: filled)
        return vals.first
    }
    
    private func getRowFilled(c: Int) -> [Int] {
        var filled = [Int]()
        for i in 0..<answer[c].count {
            let val = answer[c][i]
            filled.append(val)
        }
        return filled
    }
    
    private func getColFilled(r: Int) -> [Int] {
        var filled = [Int]()
        for i in 0..<answer.count {
            let val = answer[i][r]
            filled.append(val)
        }
        return filled
    }
    
    private func getBlockFilled(c: Int, r: Int) -> [Int] {
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
                filled.append(answer[c][r])
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
    
    fileprivate func removeFromRange(filled: [Int]) -> [Int]{
        var range = [1,2,3,4,5,6,7,8,9]
        for val in filled {
            if range.contains(val) {
                range = range.filter { $0 != val }
            }
        }
        return range.shuffled()
    }
}
