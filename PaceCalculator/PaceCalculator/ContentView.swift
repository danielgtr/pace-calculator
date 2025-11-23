//
//  ContentView.swift
//  PaceCalculator
//
//  Main view with tab-based navigation
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: AppSettings

    var strings: LocalizedStrings {
        LocalizedStrings(language: settings.language)
    }

    var body: some View {
        TabView {
            PaceConverterView()
                .tabItem {
                    Label(strings.tabConverter, systemImage: "arrow.left.arrow.right")
                }

            GoalTimeView()
                .tabItem {
                    Label(strings.tabGoalTime, systemImage: "target")
                }

            SettingsView()
                .tabItem {
                    Label(strings.settings, systemImage: "gearshape")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSettings())
}
