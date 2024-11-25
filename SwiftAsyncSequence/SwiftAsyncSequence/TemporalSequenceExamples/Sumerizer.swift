//
//  Sumerizer.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/24/24.
//

import CreateMLComponents
import Foundation

struct Sumerizer: TemporalSequence {
    
    let limit: Int
    
    typealias Feature = Int
    
    var count: Int?
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        let limitCount: Int
        
        var innerCount = 1
        
        mutating func next() async throws -> TemporalFeature<Int>? {
            
            guard innerCount <= limitCount else { return nil }
            
            let result = innerCount
            innerCount += 1
            let temporalSegmentIdentifier = TemporalSegmentIdentifier(source: "test", range: 0..<result, timescale: result)
            return TemporalFeature(id: temporalSegmentIdentifier, feature: result)
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(limitCount: limit)
    }
    
    typealias Element = TemporalFeature<Int>
    
    
}
