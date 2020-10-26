//
//  SwiftUIView.swift
//  
//
//  Created by Jean-Marc Boullianne on 6/26/20.
//

import SwiftUI

@available (iOS 14.0, macOS 10.16, *)
public struct AnimatedText: View {
    
    var charDuration: Double
    @Binding var input: String
    @State var string: String
    @State var isUpdating: Bool
    @State var nextValue: String?
    var textModifier: (Text)->(Text)
    
    public init(_ input: Binding<String>, charDuration: Double, modifier: @escaping (Text)->(Text)) {
        self._input = input
        self._string = State(initialValue: input.wrappedValue)
        self._isUpdating = State(initialValue: false)
        self.charDuration = charDuration
        self.textModifier = modifier
        
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(Array(string.enumerated()), id: \.0) { (n, ch) in
                self.textModifier(Text(String(ch)))
                
            }
        }.onChange(of: input) { newValue in
            if self.string != newValue && !self.isUpdating{
                self.nextValue = newValue
                self.isUpdating = true
                animateStringChange(newValue: newValue)
            }
            
            if let nextValue = self.nextValue, nextValue != newValue && self.isUpdating {
                self.string = nextValue
                self.nextValue = newValue
                animateStringChange(newValue: newValue)
            }
        }
    }
    
    func animateStringChange(newValue: String) {
        
        let output = needlemanWunsch(input1: self.string, input2: newValue)
        let old = output.output1
        let new = output.output2
        
        var operation: ((Int, Int, String, String) -> ())?
        
        
        operation = { (i, offset, old, new) in
            guard let nextValue = nextValue, nextValue == newValue && i < old.count else { return }
            
            if old[i] == "-" {
                let ch = new[i]
                let index = self.string.index(self.string.startIndex, offsetBy: i)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + charDuration) {
                    self.string.insert(contentsOf: ch, at: index)
                    operation?(i + 1, offset, old, new)
                }
                
            } else if new[i] == "-" {
                let index = self.string.index(self.string.startIndex, offsetBy: i + offset)
                DispatchQueue.main.asyncAfter(deadline: .now() + charDuration) {
                    self.string.remove(at: index)
                    operation?(i + 1, offset - 1, old, new)
                }
            } else if old[i] != new[i] {
                let ch = new[i]
                let startIndex = self.string.index(self.string.startIndex, offsetBy: i + offset)
                let endIndex = self.string.index(self.string.startIndex, offsetBy: i + 1 + offset)
                DispatchQueue.main.asyncAfter(deadline: .now() + charDuration) {
                    self.string.replaceSubrange(startIndex..<endIndex, with: ch)
                    operation?(i + 1, offset, old, new)
                }
            } else {
                operation?(i + 1, offset, old, new)
            }
            
            
        }
        operation?(0, 0, old, new)
    }
    
    func needlemanWunsch(input1: String, input2: String, match: Int = 5, substitution: Int = -2, gap: Int = -6)
        -> (output1: String, output2: String, score: Int) {
            
        enum Origin { case top, left, diagonal }
        
        let seq1 = Array(input1) // Horizontal, so its length sets number of columns (j)
        let seq2 = Array(input2) // Vertical, so its length sets number of rows (i)
        
        var scores: [[Int]] = []
        var paths: [[[Origin]]] = []
        
        // Initialize both matrixes with zeros.
        for _ in 0...seq2.count {
            scores.append(Array(repeatElement(0, count: seq1.count + 1)))
            paths.append(Array(repeatElement([], count: seq1.count + 1)))
        }
        
        // Initialize first rows and columns.
        for j in 1...seq1.count {
            scores[0][j] = scores[0][j - 1] + gap
            paths[0][j] = [.left]
        }
        for i in 1...seq2.count {
            scores[i][0] = scores[i - 1][0] + gap
            paths[i][0] = [.top]
        }
        
        // Populate the rest of both matrices.
        for i in 1...seq2.count {
            for j in 1...seq1.count {
                let fromTop = scores[i - 1][j] + gap
                let fromLeft = scores[i][j - 1] + gap
                let fromDiagonal = scores[i - 1][j - 1] + (seq1[j - 1] == seq2[i - 1] ? match : substitution)
                let fromMax = max(fromTop, fromLeft, fromDiagonal)
                
                scores[i][j] = fromMax
                
                if fromDiagonal == fromMax { paths[i][j].append(.diagonal) }
                if fromTop == fromMax { paths[i][j].append(.top) }
                if fromLeft == fromMax { paths[i][j].append(.left) }
            }
        }
        
        // Get the alignment representation.
        var output1 = ""
        var output2 = ""
        
        var i = seq2.count
        var j = seq1.count
        
        while !(i == 0 && j == 0) {
            switch paths[i][j].first! {
            case .diagonal:
                output1 = String(seq1[j - 1]) + output1
                output2 = String(seq2[i - 1]) + output2
                i -= 1
                j -= 1
            case .top:
                output1 = "-" + output1
                output2 = String(seq2[i - 1]) + output2
                i -= 1
            case .left:
                output1 = String(seq1[j - 1]) + output1
                output2 = "-" + output2
                j -= 1
            }
        }

        return (output1, output2, scores[seq2.count][seq1.count])
    }
}

public extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
