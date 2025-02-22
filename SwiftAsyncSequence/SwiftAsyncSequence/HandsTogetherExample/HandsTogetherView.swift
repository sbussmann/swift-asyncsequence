//
//  WindowSumView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/20/25.
//

import SwiftUI

struct HandsTogetherView: View {
    @StateObject var handsTogetherViewModel = HandsTogetherViewModel()
    
    var body: some View {
        HandsView(count: handsTogetherViewModel.uiCount)
        .onAppear {
            handsTogetherViewModel.initialize()
        }
    }
}

#Preview {
    HandsTogetherView()
}
