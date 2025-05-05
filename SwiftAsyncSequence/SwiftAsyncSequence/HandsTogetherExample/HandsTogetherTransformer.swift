//
//  WindowSumTransformer.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/25/24.
//

import CreateMLComponents
import Foundation

struct HandsTogetherPipeline {
    
    let pipeline = Downsampler(factor: 1)
    
        .appending(PoseSelector(strategy: .maximumBoundingBoxArea))
    
        .appending(JointsSelector(selectedJoints: [.leftWrist, .rightWrist] ))
    
        .appending(SlidingWindowTransformer<Pose>(stride: 30, length: 30))
    
        .appending(HandsTogetherTransformer(windowLength: 30))
    
    func count(_ poseStream: AnyTemporalSequence<[Pose]>) async throws -> HandsTogetherTransformer.CumulativeCountSequence {
//        print("floatStream: \(floatStream)")
        try await pipeline(poseStream)
    }
}

struct HandsTogetherTransformer: TemporalTransformer {
    
    let windowLength: Int
    
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {

        let deltaX = point2.x - point1.x

        let deltaY = point2.y - point1.y

        return sqrt(pow(deltaX, 2) + pow(deltaY, 2))

    }
    
    func distanceInFrame(pose: Pose) -> CGFloat? {
        let leftWrist = pose.keypoints[.leftWrist]
        let rightWrist = pose.keypoints[.rightWrist]
        
        guard let leftWrist, let rightWrist else { return nil }
        
        let leftLocation = leftWrist.location
        let rightLocation = rightWrist.location
        let distance = distanceBetweenPoints(point1: leftLocation, point2: rightLocation)
        return distance
    }
    
    func applied<S>(to input: S, eventHandler: EventHandler?) async throws -> CumulativeCountSequence where S : TemporalSequence, S.Feature == [Pose] {
        
        print("input: \(input)")
        
        var closeCount = 0
//        let tmp = input.map { poses in
//            print("poses: \(poses)")
//            poses.feature.map { pose in
//                let distance = distanceInFrame(pose: pose)
//                guard let distance else { return 0.0 }
//                if distance < 0.1 {
//                    closeCount += 1
//                }
//                print("closeCount: \(closeCount)")
//                return distance
//            }
//        }
        
        // model 
        var windowNum = 0
        for try await value in input {
            print("value.id.range: \(value.id.range)")
            for pose in value.feature {
                let distance = distanceInFrame(pose: pose)
                guard let distance else { continue }
                print("distance: \(distance)")
                if distance < 0.1 {
                    closeCount += 1
                }
            }
        }
//        let count = input.count ?? 30
        let id = TemporalSegmentIdentifier(source: "test", range: 0..<30, timescale: 30)

        return CumulativeCountSequence(count: closeCount, id: id)
    }
    
    typealias Input = [Pose]
    
    typealias Output = Int
    
    typealias OutputSequence = HandsTogetherTransformer.CumulativeCountSequence
    
    struct CumulativeCountSequence: TemporalSequence {
        typealias Feature = Int
        
        var count: Int?
        let id: TemporalSegmentIdentifier

        func makeAsyncIterator() -> AsyncIterator {
            print("count inside makeAsyncIterator: \(count ?? 10000)")
            return AsyncIterator(count: count, id: id)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            
            var count: Int?
            let id: TemporalSegmentIdentifier

            mutating func next() async throws -> TemporalFeature<Int>? {
                
                print("count: \(count ?? 10000)")
                guard var count else { return nil }
                
//                let coinFlip = Bool.random()
//                if coinFlip {
//                    innerCount += Float.random(in: 0..<1)
//                    count += 1
//                }
                let result = count
//                let temporalSegmentIdentifier = TemporalSegmentIdentifier(source: "test", range: startRange..<endRange, timescale: framesInWindow)
                return TemporalFeature(id: id, feature: result)
            }
            
            
        }
        
        typealias Element = TemporalFeature<HandsTogetherTransformer.CumulativeCountSequence.Feature>
        
        
    }
    
    
}
