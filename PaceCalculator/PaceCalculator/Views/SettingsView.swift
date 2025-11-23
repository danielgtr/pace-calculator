//
//  SettingsView.swift
//  PaceCalculator
//
//  Settings view for app preferences
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings

    var strings: LocalizedStrings {
        LocalizedStrings(language: settings.language)
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(strings.languageLabel, selection: $settings.language) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text(strings.languageLabel)
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(strings.settings)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings())
}
