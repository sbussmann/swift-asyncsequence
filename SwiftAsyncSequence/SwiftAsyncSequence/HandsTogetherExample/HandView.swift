//
//  FloatsView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/20/25.
//

import SwiftUI

struct HandsView: View {
    
    let count: Int
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Hands Together!")
                    .font(.title)
//                Text("\(count, specifier: "%2.1f")")
                Text("\(count)")
                    .font(.title)
            }
            Spacer()
            
        }
    }
}

#Preview {
    HandsView(count: 1)
}
