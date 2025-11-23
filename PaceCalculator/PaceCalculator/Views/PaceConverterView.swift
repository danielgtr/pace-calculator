//
//  PaceConverterView.swift
//  PaceCalculator
//
//  View for converting pace between different units
//

import SwiftUI

enum ConversionMode: String, CaseIterable {
    case pace = "Pace"
    case speed = "Velocidad"
}

struct PaceConverterView: View {
    @State private var conversionMode: ConversionMode = .pace

    // Pace inputs
    @State private var minutes: Int = 5
    @State private var seconds: Int = 30
    @State private var selectedPaceUnit: PaceUnit = .minPerKm

    // Speed input
    @State private var speedKmh: Double = 12.0

    @State private var result: PaceCalculator.PaceConversion?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Mode Selector
                    Picker("Modo", selection: $conversionMode) {
                        ForEach(ConversionMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
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
                            Text("Introduce un pace")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            // Time Pickers
                            HStack(spacing: 16) {
                                VStack {
                                    Text("Minutos")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker("Minutos", selection: $minutes) {
                                        ForEach(0..<60) { min in
                                            Text("\(min)").tag(min)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 120)
                                    .clipped()
                                }

                                VStack {
                                    Text("Segundos")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Picker("Segundos", selection: $seconds) {
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
                            Picker("Unidad de pace", selection: $selectedPaceUnit) {
                                Text("min/km").tag(PaceUnit.minPerKm)
                                Text("min/mi").tag(PaceUnit.minPerMile)
                            }
                            .pickerStyle(.segmented)

                            Text("El pace se mostrará en \(selectedPaceUnit.displayName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    } else {
                        // Speed Input Mode
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Introduce velocidad")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                TextField("Velocidad", value: $speedKmh, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(size: 48, weight: .bold))
                                    .multilineTextAlignment(.center)

                                Text("km/h")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text("Ejemplo: 12 km/h para pace de 5:00 min/km")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }

                    // Convert Button
                    Button(action: convert) {
                        Text("Convertir")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.purple, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }

                    // Results Section
                    if let result = result {
                        VStack(spacing: 12) {
                            Text("Resultados")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Pace Display
                            VStack(spacing: 12) {
                                VStack(spacing: 8) {
                                    Text("Pace min/km")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(result.pace)
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundColor(.purple)
                                    Text("min/km")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(12)

                                // Pace per mile (calculated from km)
                                let pacePerMileSeconds = result.paceSeconds * PaceCalculator.mileToKm
                                let pacePerMile = PaceCalculator.secondsToTime(pacePerMileSeconds)

                                ResultRow(
                                    label: "Pace por milla",
                                    value: PaceCalculator.formatTime(minutes: pacePerMile.minutes, seconds: pacePerMile.seconds)
                                )
                            }

                            ResultRow(
                                label: "Velocidad (km/h)",
                                value: String(format: "%.1f km/h", result.speedKmh),
                                highlighted: true
                            )
                            ResultRow(
                                label: "Velocidad (mph)",
                                value: String(format: "%.1f mph", result.speedMph)
                            )
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.3)],
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
            .navigationTitle("Convertidor de Pace")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func convert() {
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
