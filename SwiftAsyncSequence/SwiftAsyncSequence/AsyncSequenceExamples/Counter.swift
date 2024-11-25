//
//  Counter.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/17/24.
//

import Foundation

struct Counter: AsyncSequence {
    
    // help the compiler understand the type of each element in the sequence
    typealias Element = Int
    
    let limit: Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        let howHigh: Int
        
        var current = 1
        
        mutating func next() async -> Int? {
            guard !Task.isCancelled else { return nil }
            
            guard current <= howHigh else { return nil }
            
            let result = current
            current += 1
            
            return result
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(howHigh: limit)
    }
    
}
