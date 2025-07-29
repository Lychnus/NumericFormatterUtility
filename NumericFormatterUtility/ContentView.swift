//
//  ContentView.swift
//  NumericFormatterUtility
//
//  Created by Tahir Anil Oghan on 28.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLocale: LocaleOption = .englishUS
    private let value: Double = 1234.5678

    var body: some View {
        NavigationView {
            VStack {
                Picker("Locale", selection: $selectedLocale) {
                    ForEach(LocaleOption.allCases, id: \.self) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    Section("Decimal") {
                        Text(FormatterTools.numericFormatter.format(value, as: .decimal(locale: selectedLocale.locale)) ?? "-")
                    }

                    Section("Currency") {
                        Text(FormatterTools.numericFormatter.format(value, as: .currency(.common(.USD), locale: selectedLocale.locale)) ?? "-")
                        Text(FormatterTools.numericFormatter.format(value, as: .currency(.common(.TRY), locale: selectedLocale.locale)) ?? "-")
                    }

                    Section("Percent") {
                        Text(FormatterTools.numericFormatter.format(0.42, as: .percent(locale: selectedLocale.locale)) ?? "-")
                    }

                    Section("Scientific") {
                        Text(FormatterTools.numericFormatter.format(value, as: .scientific(locale: selectedLocale.locale)) ?? "-")
                    }

                    Section("Spell Out") {
                        Text(FormatterTools.numericFormatter.format(42, as: .spellOut(locale: selectedLocale.locale)) ?? "-")
                    }

                    Section("Ordinal") {
                        ForEach(1..<5) { number in
                            Text(FormatterTools.numericFormatter.format(number, as: .ordinal(locale: selectedLocale.locale)) ?? "-")
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Formatter Showcase")
        }
    }
}

// MARK: - Locale Option Enum

enum LocaleOption: CaseIterable {
    case englishUS
    case turkish

    var label: String {
        switch self {
            case .englishUS: return "🇺🇸 English (US)"
            case .turkish:   return "🇹🇷 Turkish (TR)"
        }
    }

    var locale: Locale {
        switch self {
            case .englishUS: return Locale(identifier: "en_US")
            case .turkish:   return Locale(identifier: "tr_TR")
        }
    }
}

#Preview {
    ContentView()
}
