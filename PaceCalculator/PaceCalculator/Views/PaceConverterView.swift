//
//  PaceConverterView.swift
//  PaceCalculator
//
//  View for converting pace between different units
//

import SwiftUI

struct PaceConverterView: View {
    @State private var minutes: Int = 5
    @State private var seconds: Int = 30
    @State private var selectedUnit: DistanceUnit = .km
    @State private var result: PaceCalculator.PaceConversion?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Input Section
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

                        // Unit Picker
                        Picker("Unidad", selection: $selectedUnit) {
                            Text("por km").tag(DistanceUnit.km)
                            Text("por milla").tag(DistanceUnit.mile)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Convert Button
                    Button(action: convertPace) {
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
                            Text("Conversiones")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ResultRow(label: "Pace por km", value: result.pacePerKm)
                            ResultRow(label: "Pace por milla", value: result.pacePerMile)
                            ResultRow(
                                label: "Velocidad (km/h)",
                                value: String(format: "%.1f km/h", result.speedKmh),
                                highlighted: true
                            )
                            ResultRow(label: "Velocidad (mph)", value: String(format: "%.1f mph", result.speedMph))
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

    private func convertPace() {
        withAnimation(.spring(response: 0.3)) {
            result = PaceCalculator.convertPace(
                minutes: minutes,
                seconds: seconds,
                unit: selectedUnit
            )
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
