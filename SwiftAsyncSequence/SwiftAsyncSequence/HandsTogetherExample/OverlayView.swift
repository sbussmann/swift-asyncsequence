//
//  OverlayView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 2/19/25.
//

import SwiftUI

/// - Tag: OverlayView
struct OverlayView: View {

    let count: Int
    let flip: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Count")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(count, specifier: "%2.0f")")
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
            }.bubbleBackground()

            Spacer()

            HStack {
                Button {
                    flip()
                } label: {
                    Label("Flip", systemImage: "arrow.triangle.2.circlepath.camera.fill")
                        .foregroundColor(.primary)
                        .labelStyle(.iconOnly)
                        .bubbleBackground()
                }

                Spacer()
            }
        }.padding()
    }
}

extension View {
    func bubbleBackground() -> some View {
        self.padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.primary)
                    .opacity(0.4)
            }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView(count: 3) { }
            .background(Color.red.opacity(0.4))

    }
}
