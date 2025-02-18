//
//  WindowSumView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/20/25.
//

import SwiftUI

struct WindowSumView: View {
    @StateObject var windowSumViewModel = WindowSumViewModel()
    
    var body: some View {
        FloatsView(count: windowSumViewModel.sumCount)
        .onAppear {
            windowSumViewModel.initialize()
        }
    }
}

#Preview {
    WindowSumView()
}
