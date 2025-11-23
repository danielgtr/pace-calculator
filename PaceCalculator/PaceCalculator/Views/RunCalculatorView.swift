//
//  RunCalculatorView.swift
//  PaceCalculator
//
//  View for calculating run time and pace based on distance
//

import SwiftUI

struct RunCalculatorView: View {
    @State private var distance: Double = 10.0
    @State private var distanceUnit: DistanceUnit = .km
    @State private var paceMinutes: Int = 5
    @State private var paceSeconds: Int = 0
    @State private var paceUnit: DistanceUnit = .km
    @State private var result: PaceCalculator.RunCalculation?
    @State private var showingPresets = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Distance Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Distancia")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: { showingPresets.toggle() }) {
                                Label("Presets", systemImage: "list.bullet")
                                    .font(.subheadline)
                            }
                        }

                        HStack(spacing: 12) {
                            TextField("Distancia", value: $distance, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            Picker("Unidad de distancia", selection: $distanceUnit) {
                                Text("km").tag(DistanceUnit.km)
                                Text("mi").tag(DistanceUnit.mile)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 120)
                        }

                        // Preset Distance Pills
                        if showingPresets {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(CommonDistance.presets, id: \.name) { preset in
                                        Button(action: {
                                            distance = distanceUnit == .km ? preset.km : preset.miles
                                        }) {
                                            Text(preset.name)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.purple.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Pace Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Pace objetivo")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 16) {
                            VStack {
                                Text("Min")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Picker("Minutos", selection: $paceMinutes) {
                                    ForEach(0..<30) { min in
                                        Text("\(min)").tag(min)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }

                            VStack {
                                Text("Seg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Picker("Segundos", selection: $paceSeconds) {
                                    ForEach(0..<60) { sec in
                                        Text("\(sec)").tag(sec)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }
                        }

                        Picker("Unidad de pace", selection: $paceUnit) {
                            Text("por km").tag(DistanceUnit.km)
                            Text("por milla").tag(DistanceUnit.mile)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Calculate Button
                    Button(action: calculate) {
                        Text("Calcular")
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
                            Text("Resultados del entrenamiento")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ResultRow(
                                label: "Distancia",
                                value: String(format: "%.1f km / %.1f mi", result.distanceKm, result.distanceMiles)
                            )
                            ResultRow(
                                label: "Tiempo total",
                                value: result.totalTime,
                                highlighted: true
                            )
                            ResultRow(label: "Pace por km", value: result.pacePerKm)
                            ResultRow(label: "Pace por milla", value: result.pacePerMile)
                            ResultRow(
                                label: "Velocidad caminadora",
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
            .navigationTitle("Calculadora de Carrera")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func calculate() {
        withAnimation(.spring(response: 0.3)) {
            result = PaceCalculator.calculateRun(
                distance: distance,
                distanceUnit: distanceUnit,
                paceMinutes: paceMinutes,
                paceSeconds: paceSeconds,
                paceUnit: paceUnit
            )
        }
    }
}

#Preview {
    RunCalculatorView()
}
