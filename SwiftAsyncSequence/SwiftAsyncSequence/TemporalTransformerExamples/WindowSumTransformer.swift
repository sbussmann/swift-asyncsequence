//
//  WindowSumTransformer.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/25/24.
//

import CreateMLComponents
import Foundation

struct WindowSumPipeline {
    
    let pipeline = Downsampler(factor: 1)
    
        .appending(SlidingWindowTransformer<Float>(stride: 60, length: 20))
    
        .appending(WindowSumTransformer())
    
    func sum(_ floatStream: AnyTemporalSequence<Float>) async throws -> WindowSumTransformer.CumulativeSumSequence {
        print("floatStream: \(floatStream)")
        return try await pipeline(floatStream)
    }
}

struct WindowSumTransformer: TemporalTransformer {
    func applied<S>(to input: S, eventHandler: EventHandler?) async throws -> CumulativeSumSequence where S : TemporalSequence, [Float] == S.Feature {
        
        print("input: \(input)")
        
        // model 
        var totalSum = Float(0)
        for try await value in input {
            let windowSum = value.feature.reduce(0, +)
            totalSum += abs(windowSum)
            print("totalSum: \(totalSum)")
            if totalSum > 10 {
                print("exited for loop in WindowSumTransformer applied method")
                return CumulativeSumSequence(limit: 30, count: Int(totalSum))
            }
        }
//        let count = input.count ?? 30
        return CumulativeSumSequence(limit: 30.0, count: Int(totalSum))
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
            print("count inside makeAsyncIterator: \(count ?? 10000)")
            return AsyncIterator(limitCount: limit, count: count)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            
            let limitCount: Float
            var count: Int?
            
            var innerCount: Float = 0

            mutating func next() async throws -> TemporalFeature<Float>? {
                
                print("limitCount: \(limitCount), innerCount: \(innerCount)")
                guard innerCount <= limitCount else { return nil }
                print("count: \(count ?? 10000)")
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
