//
//  PaceConverterView.swift
//  PaceCalculator
//
//  View for converting pace between different units
//

import SwiftUI

enum ConversionMode: CaseIterable {
    case pace
    case speed

    func displayName(language: AppLanguage) -> String {
        switch self {
        case .pace:
            return "Pace"
        case .speed:
            return language == .english ? "Speed" : "Velocidad"
        }
    }
}

struct PaceConverterView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var conversionMode: ConversionMode = .pace

    // Pace inputs
    @State private var minutes: Int = 5
    @State private var seconds: Int = 30
    @State private var selectedPaceUnit: PaceUnit = .minPerKm

    // Speed input
    @State private var speedKmh: Double = 12.0

    @State private var result: PaceCalculator.PaceConversion?
    @FocusState private var isSpeedFieldFocused: Bool

    var strings: LocalizedStrings {
        LocalizedStrings(language: settings.language)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Mode Selector
                    Picker(strings.modeLabel, selection: $conversionMode) {
                        ForEach(ConversionMode.allCases, id: \.self) { mode in
                            Text(mode.displayName(language: settings.language)).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .onChange(of: conversionMode) { _ in
                        result = nil // Clear results when switching modes
                    }

                    // Input Section
                    if conversionMode == .pace {
                        // Pace Input Mode
                        VStack(alignment: .leading, spacing: 16) {
                            Text(strings.enterPace)
                                .font(.headline)
                                .foregroundColor(.secondary)

                            // Time Pickers
                            HStack(spacing: 16) {
                                VStack {
                                    Text(strings.minutes)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker(strings.minutes, selection: $minutes) {
                                        ForEach(0..<60) { min in
                                            Text("\(min)").tag(min)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 120)
                                    .clipped()
                                }

                                VStack {
                                    Text(strings.seconds)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker(strings.seconds, selection: $seconds) {
                                        ForEach(0..<60) { sec in
                                            Text("\(sec)").tag(sec)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 120)
                                    .clipped()
                                }
                            }

                            // Pace Unit Picker
                            Picker(strings.paceUnit, selection: $selectedPaceUnit) {
                                Text("min/km").tag(PaceUnit.minPerKm)
                                Text("min/mi").tag(PaceUnit.minPerMile)
                            }
                            .pickerStyle(.segmented)

                            Text("\(strings.paceWillBeShown) \(selectedPaceUnit.displayName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    } else {
                        // Speed Input Mode
                        VStack(alignment: .leading, spacing: 16) {
                            Text(strings.enterSpeed)
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                TextField(strings.modeSpeed, value: $speedKmh, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(size: 48, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .focused($isSpeedFieldFocused)

                                Text("km/h")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(strings.speedExample)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }

                    // Convert Button
                    Button(action: convert) {
                        Text(strings.convert)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.4, green: 0.5, blue: 0.9), Color(red: 0.5, green: 0.6, blue: 0.95)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }

                    // Results Section
                    if let result = result {
                        VStack(spacing: 12) {
                            Text(strings.results)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Pace Display - show in selected unit first
                            VStack(spacing: 12) {
                                // Main result in selected unit
                                VStack(spacing: 8) {
                                    Text(selectedPaceUnit == .minPerKm ? "Pace min/km" : "Pace min/mi")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(result.pace)
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.9))
                                    Text(selectedPaceUnit.displayName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.1))
                                .cornerRadius(12)

                                // Other unit calculation
                                let otherUnitSeconds: Double
                                let otherUnitLabel: String

                                if selectedPaceUnit == .minPerKm {
                                    // Selected min/km, show min/mi
                                    otherUnitSeconds = result.paceSeconds * PaceCalculator.mileToKm
                                    otherUnitLabel = strings.pacePerMile
                                } else {
                                    // Selected min/mi, show min/km
                                    otherUnitSeconds = result.paceSeconds * PaceCalculator.kmToMile
                                    otherUnitLabel = "Pace min/km"
                                }

                                let otherUnitTime = PaceCalculator.secondsToTime(otherUnitSeconds)

                                ResultRow(
                                    label: otherUnitLabel,
                                    value: PaceCalculator.formatTime(minutes: otherUnitTime.minutes, seconds: otherUnitTime.seconds)
                                )
                            }

                            ResultRow(
                                label: strings.speedKmh,
                                value: String(format: "%.1f km/h", result.speedKmh),
                                highlighted: true
                            )
                            ResultRow(
                                label: strings.speedMph,
                                value: String(format: "%.1f mph", result.speedMph)
                            )
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.5, green: 0.6, blue: 0.95).opacity(0.3), Color(red: 0.4, green: 0.5, blue: 0.9).opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .transition(.scale.combined(with: .opacity))
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(strings.navTitleConverter)
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func convert() {
        // Dismiss keyboard
        isSpeedFieldFocused = false

        withAnimation(.spring(response: 0.3)) {
            if conversionMode == .pace {
                result = PaceCalculator.convertPace(
                    minutes: minutes,
                    seconds: seconds,
                    paceUnit: selectedPaceUnit
                )
            } else {
                result = PaceCalculator.convertSpeedToPace(speedKmh: speedKmh)
            }
        }
    }
}

// MARK: - Result Row Component

struct ResultRow: View {
    let label: String
    let value: String
    var highlighted: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(highlighted ? .purple : .primary)
        }
        .padding()
        .background(highlighted ? Color.purple.opacity(0.1) : Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    PaceConverterView()
}
