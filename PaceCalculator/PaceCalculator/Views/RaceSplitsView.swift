//
//  RaceSplitsView.swift
//  PaceCalculator
//
//  View for calculating race splits
//

import SwiftUI

struct RaceSplitsView: View {
    @State private var totalDistance: Double = 21.0975
    @State private var distanceUnit: DistanceUnit = .km
    @State private var splitInterval: Double = 1.0
    @State private var paceMinutes: Int = 5
    @State private var paceSeconds: Int = 0
    @State private var paceUnit: DistanceUnit = .km
    @State private var splits: [PaceCalculator.Split] = []
    @State private var showingPresets = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Info Banner
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Calcula tus splits para carreras")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    // Total Distance Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Distancia total")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: { showingPresets.toggle() }) {
                                Label("Carreras", systemImage: "flag.fill")
                                    .font(.subheadline)
                            }
                        }

                        HStack(spacing: 12) {
                            TextField("Distancia", value: $totalDistance, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            Picker("Unidad", selection: $distanceUnit) {
                                Text("km").tag(DistanceUnit.km)
                                Text("mi").tag(DistanceUnit.mile)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 120)
                        }

                        // Race Presets
                        if showingPresets {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(CommonDistance.presets, id: \.name) { preset in
                                        Button(action: {
                                            totalDistance = distanceUnit == .km ? preset.km : preset.miles
                                        }) {
                                            VStack(spacing: 4) {
                                                Text(preset.name)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                Text(distanceUnit == .km ?
                                                     String(format: "%.1f km", preset.km) :
                                                     String(format: "%.1f mi", preset.miles))
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.purple.opacity(0.2))
                                            .cornerRadius(12)
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

                    // Split Interval Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Intervalo de split")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            TextField("Intervalo", value: $splitInterval, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            Text(distanceUnit == .km ? "km" : "mi")
                                .foregroundColor(.secondary)
                                .frame(width: 40)
                        }

                        Text("Común: 1 km, 1 mi, o 5 km")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
                    Button(action: calculateSplits) {
                        Text("Calcular Splits")
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

                    // Splits Results
                    if !splits.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Splits de Carrera")
                                .font(.headline)

                            // Header
                            HStack {
                                Text("Distancia")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Split")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 70, alignment: .center)
                                Text("Acumulado")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 90, alignment: .trailing)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)

                            // Splits List
                            ForEach(Array(splits.enumerated()), id: \.offset) { index, split in
                                HStack {
                                    Text(String(format: "%.1f %@",
                                               split.distance,
                                               distanceUnit == .km ? "km" : "mi"))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(split.time)
                                        .fontWeight(.medium)
                                        .frame(width: 70, alignment: .center)
                                    Text(split.cumulativeTime)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.purple)
                                        .frame(width: 90, alignment: .trailing)
                                }
                                .padding()
                                .background(index % 2 == 0 ? Color(.systemGray6) : Color(.systemBackground))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
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
            .navigationTitle("Splits de Carrera")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func calculateSplits() {
        withAnimation(.spring(response: 0.3)) {
            splits = PaceCalculator.calculateSplits(
                totalDistance: totalDistance,
                distanceUnit: distanceUnit,
                splitInterval: splitInterval,
                paceMinutes: paceMinutes,
                paceSeconds: paceSeconds,
                paceUnit: paceUnit
            )
        }
    }
}

#Preview {
    RaceSplitsView()
}
