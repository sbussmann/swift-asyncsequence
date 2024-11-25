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
//            await containsExactNumber(126_877_000)
//            for await count in Counter(limit: 12).filter({ $0 % 2 == 0 }) {
//                print(count)
//            }
            try? await printAllCounts()
        }
    }
    
    func printAllCounts() async throws {
        for try await count in Sumerizer(limit: 12) {
            print(count)
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
