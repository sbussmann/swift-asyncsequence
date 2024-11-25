//
//  File.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/15/24.
//

import Foundation

// starts from 1 and doubles itself every time it's called
struct DoubleGenerator: AsyncSequence {
    typealias Element = Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var current = 1
        
        mutating func next() async -> Int? {
            defer { current &*= 2 }
            
            if current < 0 {
                return nil
            } else {
                return current
            }
        }
        
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator()
    }
}
