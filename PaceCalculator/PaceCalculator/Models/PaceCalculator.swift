//
//  PaceCalculator.swift
//  PaceCalculator
//
//  Core calculation logic for running pace conversions
//

import Foundation

struct PaceCalculator {
    static let kmToMile = 0.621371
    static let mileToKm = 1.609344

    // MARK: - Time Conversion

    static func timeToSeconds(minutes: Int, seconds: Int) -> Double {
        return Double(minutes * 60 + seconds)
    }

    static func secondsToTime(_ totalSeconds: Double) -> (minutes: Int, seconds: Int) {
        let minutes = Int(totalSeconds / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        return (minutes, seconds)
    }

    static func formatTime(minutes: Int, seconds: Int) -> String {
        return String(format: "%d:%02d", minutes, seconds)
    }

    static func formatDuration(totalSeconds: Double) -> String {
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Pace Conversion

    struct PaceConversion {
        let pace: String  // Always in the selected pace unit
        let paceSeconds: Double
        let speedKmh: Double
        let speedMph: Double
    }

    static func convertPace(minutes: Int, seconds: Int, paceUnit: PaceUnit) -> PaceConversion {
        let paceSeconds = timeToSeconds(minutes: minutes, seconds: seconds)

        let pacePerKmSeconds: Double

        switch paceUnit {
        case .minPerKm:
            pacePerKmSeconds = paceSeconds
        case .minPerMile:
            pacePerKmSeconds = paceSeconds * kmToMile
        }

        let speedKmh = 3600.0 / pacePerKmSeconds
        let speedMph = speedKmh * kmToMile

        return PaceConversion(
            pace: formatTime(minutes: minutes, seconds: seconds),
            paceSeconds: paceSeconds,
            speedKmh: speedKmh,
            speedMph: speedMph
        )
    }

    // MARK: - Speed to Pace Conversion

    static func convertSpeedToPace(speedKmh: Double) -> PaceConversion {
        // Calculate pace per km in seconds
        let pacePerKmSeconds = 3600.0 / speedKmh
        let pacePerKm = secondsToTime(pacePerKmSeconds)
        let speedMph = speedKmh * kmToMile

        return PaceConversion(
            pace: formatTime(minutes: pacePerKm.minutes, seconds: pacePerKm.seconds),
            paceSeconds: pacePerKmSeconds,
            speedKmh: speedKmh,
            speedMph: speedMph
        )
    }

    // MARK: - Run Calculation (Distance + Pace → Time)

    struct RunCalculation {
        let distanceKm: Double
        let distanceMiles: Double
        let totalTime: String
        let totalSeconds: Double
        let pace: String  // In the selected pace unit
        let speedKmh: Double
        let speedMph: Double
    }

    static func calculateRun(distance: Double, distanceUnit: DistanceUnit, paceMinutes: Int, paceSeconds: Int, paceUnit: PaceUnit) -> RunCalculation {
        let paceSecondsValue = timeToSeconds(minutes: paceMinutes, seconds: paceSeconds)

        // Convert distance to both units
        let distanceKm: Double
        let distanceMiles: Double

        switch distanceUnit {
        case .km:
            distanceKm = distance
            distanceMiles = distance * kmToMile
        case .mile:
            distanceMiles = distance
            distanceKm = distance * mileToKm
        }

        // Calculate total time based on pace unit
        let totalSeconds: Double
        let pacePerKmSeconds: Double

        switch paceUnit {
        case .minPerKm:
            pacePerKmSeconds = paceSecondsValue
            totalSeconds = distanceKm * paceSecondsValue
        case .minPerMile:
            pacePerKmSeconds = paceSecondsValue * kmToMile
            totalSeconds = distanceMiles * paceSecondsValue
        }

        // Calculate speeds
        let speedKmh = 3600.0 / pacePerKmSeconds
        let speedMph = speedKmh * kmToMile

        return RunCalculation(
            distanceKm: distanceKm,
            distanceMiles: distanceMiles,
            totalTime: formatDuration(totalSeconds: totalSeconds),
            totalSeconds: totalSeconds,
            pace: formatTime(minutes: paceMinutes, seconds: paceSeconds),
            speedKmh: speedKmh,
            speedMph: speedMph
        )
    }

    // MARK: - Goal Time Calculation (Distance + Time → Pace)

    struct GoalTimeCalculation {
        let distanceKm: Double
        let distanceMiles: Double
        let goalTime: String
        let pace: String  // In the selected pace unit
        let paceMinutes: Int
        let paceSeconds: Int
        let speedKmh: Double
        let speedMph: Double
    }

    static func calculatePaceFromGoalTime(distance: Double, distanceUnit: DistanceUnit, hours: Int, minutes: Int, seconds: Int, paceUnit: PaceUnit) -> GoalTimeCalculation {
        // Convert distance to both units
        let distanceKm: Double
        let distanceMiles: Double

        switch distanceUnit {
        case .km:
            distanceKm = distance
            distanceMiles = distance * kmToMile
        case .mile:
            distanceMiles = distance
            distanceKm = distance * mileToKm
        }

        // Convert goal time to seconds
        let goalTimeSeconds = Double(hours * 3600 + minutes * 60 + seconds)

        // Calculate pace per km (always calculate this first)
        let pacePerKmSeconds = goalTimeSeconds / distanceKm

        // Calculate the pace in the requested unit
        let paceInRequestedUnit: Double
        switch paceUnit {
        case .minPerKm:
            paceInRequestedUnit = pacePerKmSeconds
        case .minPerMile:
            paceInRequestedUnit = pacePerKmSeconds * mileToKm
        }

        let paceTime = secondsToTime(paceInRequestedUnit)

        // Calculate speeds
        let speedKmh = 3600.0 / pacePerKmSeconds
        let speedMph = speedKmh * kmToMile

        return GoalTimeCalculation(
            distanceKm: distanceKm,
            distanceMiles: distanceMiles,
            goalTime: formatDuration(totalSeconds: goalTimeSeconds),
            pace: formatTime(minutes: paceTime.minutes, seconds: paceTime.seconds),
            paceMinutes: paceTime.minutes,
            paceSeconds: paceTime.seconds,
            speedKmh: speedKmh,
            speedMph: speedMph
        )
    }

    // MARK: - Race Splits

    struct Split {
        let distance: Double
        let time: String
        let cumulativeTime: String
    }

    static func calculateSplits(totalDistance: Double, distanceUnit: DistanceUnit, splitInterval: Double, paceMinutes: Int, paceSeconds: Int, paceUnit: PaceUnit) -> [Split] {
        let paceSecondsValue = timeToSeconds(minutes: paceMinutes, seconds: paceSeconds)

        // Convert everything to km for consistency
        let totalDistanceKm: Double
        let splitIntervalKm: Double
        let pacePerKmSeconds: Double

        switch distanceUnit {
        case .km:
            totalDistanceKm = totalDistance
        case .mile:
            totalDistanceKm = totalDistance * mileToKm
        }

        switch distanceUnit {
        case .km:
            splitIntervalKm = splitInterval
        case .mile:
            splitIntervalKm = splitInterval * mileToKm
        }

        switch paceUnit {
        case .minPerKm:
            pacePerKmSeconds = paceSecondsValue
        case .minPerMile:
            pacePerKmSeconds = paceSecondsValue * kmToMile
        }

        // Collect all split distances (in km)
        var splitDistances: Set<Double> = []

        // Add regular interval splits
        var currentDistance: Double = 0
        while currentDistance < totalDistanceKm {
            let remainingDistance = totalDistanceKm - currentDistance
            let segmentDistance = min(splitIntervalKm, remainingDistance)
            currentDistance += segmentDistance

            // Round to avoid floating point precision issues
            let roundedDistance = round(currentDistance * 10000) / 10000
            splitDistances.insert(roundedDistance)
        }

        // Add halfway point (always included)
        let halfwayKm = totalDistanceKm / 2.0
        let roundedHalfway = round(halfwayKm * 10000) / 10000
        splitDistances.insert(roundedHalfway)

        // Sort all split distances
        let sortedDistances = splitDistances.sorted()

        // Calculate splits with cumulative times
        var splits: [Split] = []
        var cumulativeSeconds: Double = 0
        var previousDistance: Double = 0

        for distance in sortedDistances {
            let segmentDistance = distance - previousDistance
            let segmentTime = segmentDistance * pacePerKmSeconds
            cumulativeSeconds += segmentTime

            let displayDistance = distanceUnit == .km ? distance : distance * kmToMile

            splits.append(Split(
                distance: displayDistance,
                time: formatDuration(totalSeconds: segmentTime),
                cumulativeTime: formatDuration(totalSeconds: cumulativeSeconds)
            ))

            previousDistance = distance
        }

        return splits
    }
}

// MARK: - Supporting Types

enum DistanceUnit: String, CaseIterable {
    case km = "km"
    case mile = "mi"

    var displayName: String {
        switch self {
        case .km:
            return "Kilómetros"
        case .mile:
            return "Millas"
        }
    }
}

enum PaceUnit: String, CaseIterable {
    case minPerKm = "min/km"
    case minPerMile = "min/mi"

    var displayName: String {
        return self.rawValue
    }
}

struct CommonDistance {
    let name: String
    let km: Double
    let miles: Double

    static let presets: [CommonDistance] = [
        CommonDistance(name: "5K", km: 5.0, miles: 3.1),
        CommonDistance(name: "10K", km: 10.0, miles: 6.2),
        CommonDistance(name: "Media Maratón", km: 21.0975, miles: 13.1),
        CommonDistance(name: "Maratón", km: 42.195, miles: 26.2),
        CommonDistance(name: "50K", km: 50.0, miles: 31.1),
        CommonDistance(name: "100K", km: 100.0, miles: 62.1)
    ]
}
