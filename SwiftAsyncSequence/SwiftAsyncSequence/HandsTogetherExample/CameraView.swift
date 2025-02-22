//
//  CameraView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 2/19/25.
//

import SwiftUI

struct CameraView: View {

    let cameraImage: CGImage

    var body: some View {
        Image(cameraImage, scale: 1.0, label: Text("Camera"))
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(cameraImage: UIImage(systemName: "square")!.cgImage!)
    }
}
