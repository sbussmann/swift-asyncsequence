//
//  FloatsView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 1/20/25.
//

import SwiftUI

struct FloatsView: View {
    
    let count: Float
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Count")
                    .font(.title)
                Text("\(count, specifier: "%2.1f")")
                    .font(.title)
            }
            Spacer()
            
        }
    }
}

#Preview {
    FloatsView(count: 3.568)
}
