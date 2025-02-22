//
//  WindowSumViewModel.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/19/25.
//

import AsyncAlgorithms
import CreateMLComponents
import SwiftUI

class HandsTogetherViewModel: ObservableObject {
    
    @Published var liveCameraImageAndPoses: (image: CGImage, poses: [Pose])?
    
    var uiCount: Int = 0
    
    private var displayCameraTask: Task<Void, Error>?
    
    private var handsTask: Task<Void, Error>?
    
    private var previousWindowCount: Int = 0
    
    private let poseStream = AsyncChannel<TemporalFeature<[Pose]>>()
    private let poseExtractor = HumanBodyPoseExtractor()
    
    private var configuration = VideoReader.CameraConfiguration()
    
    private let handsTogetherPipeline = HandsTogetherPipeline()
    
    func initialize() {
        startPoseStream()
    }
    
    func onCameraButtonTapped() {
        toggleCameraSelection()

        // Reset the count.
        uiCount = 0

        // Restart the video processing.
        startPoseStream()
    }
    
    func toggleCameraSelection() {
        if configuration.position == .front {
            configuration.position = .back
        } else {
            configuration.position = .front
        }
    }
    
    func startPoseStream() {
        
        if let displayCameraTask = displayCameraTask {
            displayCameraTask.cancel()
        }
        
        displayCameraTask = Task {
            // Display poses on top of each camera frame.
            try await self.displayPoseInCamera()
        }
        
        if handsTask == nil {
            handsTask = Task {
                try await self.countHands()
            }
        }
    }
    
    /// Display poses on top of each camera frame.
    func displayPoseInCamera() async throws {
        // Start reading the camera.
        let frameSequence = try await VideoReader.readCamera(
            configuration: configuration
        )
        var lastTime = CFAbsoluteTimeGetCurrent()

        for try await frame in frameSequence {

            if Task.isCancelled {
                return
            }

            // Extract poses in every frame.
            let poses = try await poseExtractor.applied(to: frame.feature)

            // Send poses into another pose stream for additional consumers.
            await poseStream.send(TemporalFeature(id: frame.id, feature: poses))

            // Calculate poses from the image frame and display both.
            if let cgImage = CIContext()
                .createCGImage(frame.feature, from: frame.feature.extent) {
                await display(image: cgImage, poses: poses)
            }

            // Frame rate debug information.
//            print(String(format: "Frame rate %2.2f fps", 1 / (CFAbsoluteTimeGetCurrent() - lastTime)))
            lastTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    func countHands() async throws {
//        let frameSequence = try await VideoReader.readCamera(configuration: configuration)
        let poseTemporalSequence = AnyTemporalSequence<[Pose]>(poseStream, count: nil)
        
        let finalResults = try await handsTogetherPipeline.count(poseTemporalSequence)
        
        var lastTime = CFAbsoluteTimeGetCurrent()
        
        for try await item in finalResults {
            
            if Task.isCancelled {
                return
            }
            
            let currentCumulativeCount = item.feature
            
//            print("item: \(item)")
            
            previousWindowCount = currentCumulativeCount
//            await floatStream.send(TemporalFeature(id: frame.id, feature: randomFloat))

            // Frame rate debug information.
//            print(String(format: "Count rate %2.2f fps", 1 / (CFAbsoluteTimeGetCurrent() - lastTime)))
            lastTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    @MainActor func display(image: CGImage, poses: [Pose]) {
        self.liveCameraImageAndPoses = (image, poses)
    }

}
