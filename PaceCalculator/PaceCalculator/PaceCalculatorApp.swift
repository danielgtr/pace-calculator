//
//  PaceCalculatorApp.swift
//  PaceCalculator
//
//  Main app entry point
//

import SwiftUI

@main
struct PaceCalculatorApp: App {
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
