//
//  CameraWithPosesAndOverlaysView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 2/19/25.
//


import SwiftUI

struct CameraWithPosesAndOverlaysView: View {

    @StateObject var viewModel = HandsTogetherViewModel()

    var body: some View {
        OverlayView(count: viewModel.uiCount) {
            viewModel.onCameraButtonTapped()
        }
        .background {
            if let (image, poses) = viewModel.liveCameraImageAndPoses {
                CameraView(
                    cameraImage: image
                )
                .overlay {
                    PosesView(poses: poses)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.initialize()
        }
    }
}

struct CameraWithOverlaysView_Previews: PreviewProvider {
    static var previews: some View {
        CameraWithPosesAndOverlaysView()
    }
}
