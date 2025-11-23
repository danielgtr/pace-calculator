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

            RunCalculatorView()
                .tabItem {
                    Label("Distancia", systemImage: "figure.run")
                }

            GoalTimeView()
                .tabItem {
                    Label("Tiempo Meta", systemImage: "target")
                }

            RaceSplitsView()
                .tabItem {
                    Label("Splits", systemImage: "list.number")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
}
