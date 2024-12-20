//
//  WindowSumTransformer.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/25/24.
//

import CreateMLComponents
import Foundation

struct WindowSumTransformer: TemporalTransformer {
    func applied<S>(to input: S, eventHandler: EventHandler?) async throws -> CumulativeSumSequence where S : TemporalSequence, [Float] == S.Feature {
        return CumulativeSumSequence(limit: input.count)
//        return
    }
    
    typealias Input = [Float]
    
    typealias Output = Float
    
    typealias OutputSequence = WindowSumTransformer.CumulativeSumSequence
    
    struct CumulativeSumSequence: TemporalSequence {
        typealias Feature = Float
        
        let limit: Float
        
        var count: Int?
        
        func makeAsyncIterator() -> AsyncIterator {
            AsyncIterator(limitCount: limit, count: count)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            
            let limitCount: Float
            var count: Int?
            
            var innerCount: Float = 0

            mutating func next() async throws -> TemporalFeature<Float>? {
                
                guard innerCount <= limitCount else { return nil }
                guard var count else { return nil }
                
                let coinFlip = Bool.random()
                if coinFlip {
                    innerCount += Float.random(in: 0..<1)
                    count += 1
                }
                let result = innerCount
                let temporalSegmentIdentifier = TemporalSegmentIdentifier(source: "test", range: 0..<30, timescale: 30)
                return TemporalFeature(id: temporalSegmentIdentifier, feature: result)
            }
            
            
        }
        
        typealias Element = TemporalFeature<WindowSumTransformer.CumulativeSumSequence.Feature>
        
        
    }
    
    
}
