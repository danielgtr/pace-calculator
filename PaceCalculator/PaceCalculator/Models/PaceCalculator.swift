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
        let pacePerKm: String
        let pacePerMile: String
        let speedKmh: Double
        let speedMph: Double
    }

    static func convertPace(minutes: Int, seconds: Int, unit: DistanceUnit) -> PaceConversion {
        let paceSeconds = timeToSeconds(minutes: minutes, seconds: seconds)

        let pacePerKmSeconds: Double
        let pacePerMileSeconds: Double

        switch unit {
        case .km:
            pacePerKmSeconds = paceSeconds
            pacePerMileSeconds = paceSeconds * mileToKm
        case .mile:
            pacePerMileSeconds = paceSeconds
            pacePerKmSeconds = paceSeconds * kmToMile
        }

        let pacePerKm = secondsToTime(pacePerKmSeconds)
        let pacePerMile = secondsToTime(pacePerMileSeconds)

        let speedKmh = 3600.0 / pacePerKmSeconds
        let speedMph = 3600.0 / pacePerMileSeconds

        return PaceConversion(
            pacePerKm: formatTime(minutes: pacePerKm.minutes, seconds: pacePerKm.seconds),
            pacePerMile: formatTime(minutes: pacePerMile.minutes, seconds: pacePerMile.seconds),
            speedKmh: speedKmh,
            speedMph: speedMph
        )
    }

    // MARK: - Run Calculation

    struct RunCalculation {
        let distanceKm: Double
        let distanceMiles: Double
        let totalTime: String
        let totalSeconds: Double
        let pacePerKm: String
        let pacePerMile: String
        let speedKmh: Double
        let speedMph: Double
    }

    static func calculateRun(distance: Double, distanceUnit: DistanceUnit, paceMinutes: Int, paceSeconds: Int, paceUnit: DistanceUnit) -> RunCalculation {
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
        switch paceUnit {
        case .km:
            totalSeconds = distanceKm * paceSecondsValue
        case .mile:
            totalSeconds = distanceMiles * paceSecondsValue
        }

        // Calculate pace in both units
        let pacePerKmSeconds = paceUnit == .km ? paceSecondsValue : paceSecondsValue * kmToMile
        let pacePerMileSeconds = paceUnit == .mile ? paceSecondsValue : paceSecondsValue * mileToKm

        let pacePerKm = secondsToTime(pacePerKmSeconds)
        let pacePerMile = secondsToTime(pacePerMileSeconds)

        // Calculate speeds
        let speedKmh = 3600.0 / pacePerKmSeconds
        let speedMph = 3600.0 / pacePerMileSeconds

        return RunCalculation(
            distanceKm: distanceKm,
            distanceMiles: distanceMiles,
            totalTime: formatDuration(totalSeconds: totalSeconds),
            totalSeconds: totalSeconds,
            pacePerKm: formatTime(minutes: pacePerKm.minutes, seconds: pacePerKm.seconds),
            pacePerMile: formatTime(minutes: pacePerMile.minutes, seconds: pacePerMile.seconds),
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

    static func calculateSplits(totalDistance: Double, distanceUnit: DistanceUnit, splitInterval: Double, paceMinutes: Int, paceSeconds: Int, paceUnit: DistanceUnit) -> [Split] {
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
        case .km:
            pacePerKmSeconds = paceSecondsValue
        case .mile:
            pacePerKmSeconds = paceSecondsValue * kmToMile
        }

        var splits: [Split] = []
        var currentDistance: Double = 0
        var cumulativeSeconds: Double = 0

        while currentDistance < totalDistanceKm {
            let remainingDistance = totalDistanceKm - currentDistance
            let segmentDistance = min(splitIntervalKm, remainingDistance)

            currentDistance += segmentDistance
            let segmentTime = segmentDistance * pacePerKmSeconds
            cumulativeSeconds += segmentTime

            let displayDistance = distanceUnit == .km ? currentDistance : currentDistance * kmToMile

            splits.append(Split(
                distance: displayDistance,
                time: formatDuration(totalSeconds: segmentTime),
                cumulativeTime: formatDuration(totalSeconds: cumulativeSeconds)
            ))
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
