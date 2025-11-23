//
//  RaceSplitsView.swift
//  PaceCalculator
//
//  View for calculating race splits (accessed from GoalTimeView)
//

import SwiftUI

struct RaceSplitsView: View {
    // Data passed from GoalTimeView
    let initialDistance: Double
    let initialDistanceUnit: DistanceUnit
    let initialPaceMinutes: Int
    let initialPaceSeconds: Int
    let initialPaceUnit: PaceUnit

    @State private var totalDistance: Double
    @State private var distanceUnit: DistanceUnit
    @State private var splitInterval: Double
    @State private var paceMinutes: Int
    @State private var paceSeconds: Int
    @State private var paceUnit: PaceUnit
    @State private var splits: [PaceCalculator.Split] = []
    @State private var showingIntervalOptions = false
    @FocusState private var isIntervalFieldFocused: Bool
    @Environment(\.dismiss) var dismiss

    init(distance: Double, distanceUnit: DistanceUnit, paceMinutes: Int, paceSeconds: Int, paceUnit: PaceUnit) {
        self.initialDistance = distance
        self.initialDistanceUnit = distanceUnit
        self.initialPaceMinutes = paceMinutes
        self.initialPaceSeconds = paceSeconds
        self.initialPaceUnit = paceUnit

        // Initialize state with passed values
        _totalDistance = State(initialValue: distance)
        _distanceUnit = State(initialValue: distanceUnit)
        _paceMinutes = State(initialValue: paceMinutes)
        _paceSeconds = State(initialValue: paceSeconds)
        _paceUnit = State(initialValue: paceUnit)

        // Auto-set split interval based on distance unit (1 km or 1 mile)
        _splitInterval = State(initialValue: 1.0)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Race Splits")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("Auto interval: \(String(format: "%.0f", splitInterval)) \(distanceUnit.rawValue)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { showingIntervalOptions.toggle() }) {
                        Text(showingIntervalOptions ? "Hide" : "Change interval")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)

                // Interval Options (collapsible)
                if showingIntervalOptions {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Split interval")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            TextField("Interval", value: $splitInterval, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .frame(width: 100)
                                .focused($isIntervalFieldFocused)

                            Text(distanceUnit == .km ? "km" : "mi")
                                .foregroundColor(.secondary)

                            Spacer()
                        }

                        Text("Common: 1, 5, or 10 \(distanceUnit.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button(action: calculateSplits) {
                            Text("Recalculate")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .transition(.scale.combined(with: .opacity))
                }

                // Splits Results
                if !splits.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Splits")
                                .font(.headline)
                            Spacer()
                            Text("\(splits.count) splits")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // Header
                        HStack {
                            Text("Distance")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Split")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .center)
                            Text("Cumulative")
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
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String(format: "%.1f %@",
                                               split.distance,
                                               distanceUnit == .km ? "km" : "mi"))
                                    if let label = split.label {
                                        Text(label)
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                Text(split.time)
                                    .fontWeight(.medium)
                                    .frame(width: 70, alignment: .center)
                                Text(split.cumulativeTime)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
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
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Race Splits")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Calculate splits automatically when view appears
            calculateSplits()
        }
    }

    private func calculateSplits() {
        // Cerrar el teclado
        isIntervalFieldFocused = false

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
    NavigationView {
        RaceSplitsView(
            distance: 42.195,
            distanceUnit: .km,
            paceMinutes: 5,
            paceSeconds: 41,
            paceUnit: .minPerKm
        )
    }
}
