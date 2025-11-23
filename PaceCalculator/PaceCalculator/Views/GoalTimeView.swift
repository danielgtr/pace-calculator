//
//  GoalTimeView.swift
//  PaceCalculator
//
//  View for calculating required pace from goal time
//

import SwiftUI

struct GoalTimeView: View {
    @State private var distance: Double = 42.195
    @State private var distanceUnit: DistanceUnit = .km
    @State private var hours: Int = 3
    @State private var minutes: Int = 59
    @State private var seconds: Int = 59
    @State private var paceUnit: PaceUnit = .minPerKm
    @State private var result: PaceCalculator.GoalTimeCalculation?
    @State private var showingPresets = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Info Banner
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.green)
                        Text("Calcula el pace necesario para tu tiempo meta")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)

                    // Distance Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Distancia")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: { showingPresets.toggle() }) {
                                Label("Carreras", systemImage: "list.bullet")
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
                                            .background(Color.green.opacity(0.2))
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

                    // Goal Time Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tiempo meta")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 16) {
                            VStack {
                                Text("Horas")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Picker("Horas", selection: $hours) {
                                    ForEach(0..<24) { hour in
                                        Text("\(hour)").tag(hour)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }

                            VStack {
                                Text("Min")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Picker("Minutos", selection: $minutes) {
                                    ForEach(0..<60) { min in
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
                                Picker("Segundos", selection: $seconds) {
                                    ForEach(0..<60) { sec in
                                        Text("\(sec)").tag(sec)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }
                        }

                        Text("Ejemplo: 3:59:59 para sub-4 maratón")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Pace Unit Selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mostrar pace en")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Picker("Unidad de pace", selection: $paceUnit) {
                            Text("min/km").tag(PaceUnit.minPerKm)
                            Text("min/mi").tag(PaceUnit.minPerMile)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Calculate Button
                    Button(action: calculate) {
                        Text("Calcular Pace")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }

                    // Results Section
                    if let result = result {
                        VStack(spacing: 12) {
                            Text("Pace necesario")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Large Pace Display
                            VStack(spacing: 8) {
                                Text(result.pace)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.green)
                                Text(paceUnit.displayName)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)

                            ResultRow(
                                label: "Distancia",
                                value: String(format: "%.2f %@",
                                            distanceUnit == .km ? result.distanceKm : result.distanceMiles,
                                            distanceUnit.rawValue)
                            )
                            ResultRow(
                                label: "Tiempo meta",
                                value: result.goalTime,
                                highlighted: true
                            )
                            ResultRow(
                                label: "Velocidad caminadora",
                                value: String(format: "%.1f km/h", result.speedKmh),
                                highlighted: true
                            )
                            ResultRow(
                                label: "Velocidad (mph)",
                                value: String(format: "%.1f mph", result.speedMph)
                            )

                            // Ver Splits Button
                            NavigationLink(destination: RaceSplitsView(
                                distance: distance,
                                distanceUnit: distanceUnit,
                                paceMinutes: result.paceMinutes,
                                paceSeconds: result.paceSeconds,
                                paceUnit: paceUnit
                            )) {
                                HStack {
                                    Image(systemName: "list.number")
                                    Text("Ver Splits de Carrera")
                                        .fontWeight(.semibold)
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.green.opacity(0.2), Color.blue.opacity(0.2)],
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
            .navigationTitle("Tiempo Meta → Pace")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func calculate() {
        withAnimation(.spring(response: 0.3)) {
            result = PaceCalculator.calculatePaceFromGoalTime(
                distance: distance,
                distanceUnit: distanceUnit,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                paceUnit: paceUnit
            )
        }
    }
}

#Preview {
    GoalTimeView()
}
