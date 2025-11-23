//
//  ContentView.swift
//  PaceCalculator
//
//  Main view with tab-based navigation
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PaceConverterView()
                .tabItem {
                    Label("Converter", systemImage: "arrow.left.arrow.right")
                }

            GoalTimeView()
                .tabItem {
                    Label("Goal Time", systemImage: "target")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
