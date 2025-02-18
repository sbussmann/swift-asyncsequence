//
//  WindowSumViewModel.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/19/25.
//

import AsyncAlgorithms
import CreateMLComponents
import SwiftUI

class WindowSumViewModel: ObservableObject {
    
    var sumCount: Float = 0.0
    
    private var generateFloatsTask: Task<Void, Error>?
    
    private var sumTask: Task<Void, Error>?
    
    private var lastSumCount: Float = 0.0
    
    private let floatStream = AsyncChannel<TemporalFeature<Float>>()
    
    private var configuration = VideoReader.CameraConfiguration()
    
    private let windowSumPipeline = WindowSumPipeline()
    
    func initialize() {
        startFloatStream()
    }
    
    func startFloatStream() {
        
        if let generateFloatsTask = generateFloatsTask {
            generateFloatsTask.cancel()
        }
        
        generateFloatsTask = Task {
            try await self.generateFloats()
        }
        
        if sumTask == nil {
            sumTask = Task {
                try await self.sumFloats()
            }
        }
    }
    
    func generateFloats() async throws {
        let frameSequence = try await VideoReader.readCamera(configuration: configuration)
        
//        var lastTime = CFAbsoluteTimeGetCurrent()
        
        for try await frame in frameSequence {
            
            if Task.isCancelled {
                return
            }
            
//            let randomFloat = Float.random(in: 0...1)
            let randomFloat = Float(frame.hashValue) / Float(Int.max)
//            print("randomFloat: \(randomFloat)")

            await floatStream.send(TemporalFeature(id: frame.id, feature: randomFloat))

            // Frame rate debug information.
//            print(String(format: "Frame rate %2.2f fps", 1 / (CFAbsoluteTimeGetCurrent() - lastTime)))
//            lastTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    func sumFloats() async throws {
        
        print("summing floats...")

        let floatTemporalSequence = AnyTemporalSequence<Float>(floatStream, count: nil)
        
        let finalResults = try await windowSumPipeline.sum(floatTemporalSequence)
        
        var lastTime = CFAbsoluteTimeGetCurrent()
        
        for try await item in finalResults {
            
            print("item: \(item)")
            
            if Task.isCancelled {
                return
            }
            
            let currentSumCount = item.feature
            
            sumCount += currentSumCount - lastSumCount
            
            print("""
                    Cumulative sum count \(currentSumCount), last sum count \(lastSumCount), \
                    incremental sum count \(currentSumCount - lastSumCount), sum count \(sumCount)
                    """)
            
            lastSumCount = currentSumCount
            
            print(String(format: "Count rate %2.2f fps", 1 / (CFAbsoluteTimeGetCurrent() - lastTime)))
            lastTime = CFAbsoluteTimeGetCurrent()
        }
    }
}
