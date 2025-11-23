//
//  AppSettings.swift
//  PaceCalculator
//
//  App settings and language management
//

import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case spanish = "Español"

    var code: String {
        switch self {
        case .english: return "en"
        case .spanish: return "es"
        }
    }
}

class AppSettings: ObservableObject {
    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "appLanguage")
        }
    }

    init() {
        // Default to English
        let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage")
        self.language = AppLanguage(rawValue: savedLanguage ?? AppLanguage.english.rawValue) ?? .english
    }
}

// Localized strings helper
struct LocalizedStrings {
    let language: AppLanguage

    // MARK: - Tab Labels
    var tabConverter: String {
        language == .english ? "Converter" : "Convertidor"
    }

    var tabGoalTime: String {
        language == .english ? "Goal Time" : "Tiempo Meta"
    }

    // MARK: - PaceConverterView
    var navTitleConverter: String {
        language == .english ? "Pace Converter" : "Convertidor de Pace"
    }

    var modeLabel: String {
        language == .english ? "Mode" : "Modo"
    }

    var modePace: String {
        "Pace"
    }

    var modeSpeed: String {
        language == .english ? "Speed" : "Velocidad"
    }

    var enterPace: String {
        language == .english ? "Enter a pace" : "Introduce un pace"
    }

    var minutes: String {
        language == .english ? "Minutes" : "Minutos"
    }

    var seconds: String {
        language == .english ? "Seconds" : "Segundos"
    }

    var paceUnit: String {
        language == .english ? "Pace unit" : "Unidad de pace"
    }

    var paceWillBeShown: String {
        language == .english ? "Pace will be shown in" : "El pace se mostrará en"
    }

    var enterSpeed: String {
        language == .english ? "Enter speed" : "Introduce velocidad"
    }

    var speedExample: String {
        language == .english ? "Example: 12 km/h for 5:00 min/km pace" : "Ejemplo: 12 km/h para pace de 5:00 min/km"
    }

    var convert: String {
        language == .english ? "Convert" : "Convertir"
    }

    var results: String {
        language == .english ? "Results" : "Resultados"
    }

    var pacePerMile: String {
        language == .english ? "Pace per mile" : "Pace por milla"
    }

    var speedKmh: String {
        language == .english ? "Speed (km/h)" : "Velocidad (km/h)"
    }

    var speedMph: String {
        language == .english ? "Speed (mph)" : "Velocidad (mph)"
    }

    // MARK: - GoalTimeView
    var navTitleGoalTime: String {
        language == .english ? "Goal Time → Pace" : "Tiempo Meta → Pace"
    }

    var calculatePaceMessage: String {
        language == .english ? "Calculate the pace you need for your goal time" : "Calcula el pace necesario para tu tiempo meta"
    }

    var distance: String {
        language == .english ? "Distance" : "Distancia"
    }

    var races: String {
        language == .english ? "Races" : "Carreras"
    }

    var goalTime: String {
        language == .english ? "Goal Time" : "Tiempo meta"
    }

    var hours: String {
        language == .english ? "Hours" : "Horas"
    }

    var min: String {
        "Min"
    }

    var sec: String {
        "Sec"
    }

    var goalTimeExample: String {
        language == .english ? "Example: 3:59:59 for sub-4 marathon" : "Ejemplo: 3:59:59 para sub-4 maratón"
    }

    var showPaceIn: String {
        language == .english ? "Show pace in" : "Mostrar pace en"
    }

    var calculatePace: String {
        language == .english ? "Calculate Pace" : "Calcular Pace"
    }

    var requiredPace: String {
        language == .english ? "Required Pace" : "Pace necesario"
    }

    var treadmillSpeed: String {
        language == .english ? "Treadmill Speed" : "Velocidad caminadora"
    }

    var viewRaceSplits: String {
        language == .english ? "View Race Splits" : "Ver Splits de Carrera"
    }

    // MARK: - RaceSplitsView
    var navTitleSplits: String {
        language == .english ? "Race Splits" : "Splits de Carrera"
    }

    var raceSplits: String {
        language == .english ? "Race Splits" : "Splits de Carrera"
    }

    var autoInterval: String {
        language == .english ? "Auto interval" : "Intervalo automático"
    }

    var hide: String {
        language == .english ? "Hide" : "Ocultar"
    }

    var changeInterval: String {
        language == .english ? "Change interval" : "Cambiar intervalo"
    }

    var splitInterval: String {
        language == .english ? "Split interval" : "Intervalo de split"
    }

    var interval: String {
        language == .english ? "Interval" : "Intervalo"
    }

    var commonIntervals: String {
        language == .english ? "Common: 1, 5, or 10" : "Común: 1, 5, o 10"
    }

    var recalculate: String {
        language == .english ? "Recalculate" : "Recalcular"
    }

    var splits: String {
        "Splits"
    }

    var cumulative: String {
        language == .english ? "Cumulative" : "Acumulado"
    }

    var halfwayPoint: String {
        language == .english ? "Halfway Point" : "Punto Medio"
    }

    // MARK: - Settings
    var settings: String {
        language == .english ? "Settings" : "Configuración"
    }

    var languageLabel: String {
        language == .english ? "Language" : "Idioma"
    }
}
