//
//  ContentView.swift
//  SwiftAsyncSequence
//
//  Created by Shane Bussmann on 11/15/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
//            await printAllDoubles()
            await containsExactNumber(126_877_000)
        }
    }
    
    func printAllDoubles() async {
        for await number in DoubleGenerator() {
            print(number)
        }
    }
    
    func containsExactNumber(_ number: Int) async {
        let doubles = DoubleGenerator()
        let match = await doubles.contains(number)
        print("DoubleGenerator contains \(number): \(match)")
    }
}

#Preview {
    ContentView()
}
