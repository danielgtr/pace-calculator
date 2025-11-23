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
                    Label("Convertidor", systemImage: "arrow.left.arrow.right")
                }

            GoalTimeView()
                .tabItem {
                    Label("Tiempo Meta", systemImage: "target")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
