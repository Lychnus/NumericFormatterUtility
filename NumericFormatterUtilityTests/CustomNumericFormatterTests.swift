//
//  CustomNumericFormatterTests.swift
//  NumericFormatterUtilityTests
//
//  Created by Tahir Anil Oghan on 28.07.2025.
//

import Foundation
import Testing
@testable import NumericFormatterUtility

@Suite("CustomNumericFormatter Tests")
struct CustomNumericFormatterTests {
    
    // MARK: - NumericFormatterISO4217 Tests
    
    @Test("NumericFormatterISO4217 contains exactly all common codes.")
    func testNumericFormatterISO4217Codes() {
        let systemCodes = Set(Locale.commonISOCurrencyCodes)
        let customCodes = Set(NumericFormatterISO4217.allCases.map({ $0.rawValue }))
        
        #expect(systemCodes == customCodes)
    }
    
    @Test("NumericFormatterISO4217 rawValue returns valid ISO codes.")
    func testNumericFormatterISO4217RawValue() {
        let systemCodes = Set(Locale.commonISOCurrencyCodes)
        let customCodes = NumericFormatterISO4217.allCases.map({ $0.rawValue })
        
        for code in customCodes {
            #expect(systemCodes.contains(code))
        }
    }
    
    @Test("NumericFormatterISO4217 No missing, No extra.")
    func testNumericFormatterISO4217NoMissingNoExtra() {
        let systemCodes = Set(Locale.commonISOCurrencyCodes)
        let customCodes = Set(NumericFormatterISO4217.allCases.map({ $0.rawValue }))

        let missing = systemCodes.subtracting(customCodes)
        let extra = customCodes.subtracting(systemCodes)

        #expect(missing.isEmpty && extra.isEmpty, "Missing: \(missing), Extra: \(extra)")
    }
    
    // MARK: - NumericFormatterCurrency Tests
    
    @Test("NumericFormatterCurrency.common returns correct rawValue as description.")
    func testNumericFormatterCurrencyCommonDescription() {
        let currency = NumericFormatterCurrency.common(.USD)
        
        #expect(currency.description == "USD")
    }

    @Test("NumericFormatterCurrency.custom returns exact string as description.")
    func testNumericFormatterCurrencyCustomDescription() {
        let currency = NumericFormatterCurrency.custom("XXX")
        
        #expect(currency.description == "XXX")
    }

    // MARK: - NumericFormatterStyle Tests
    
    @Test("NumericFormatterStyle configure sets correct numberStyle and locale for each style.")
    func testFormatterConfiguration() {
        let trLocale = Locale(identifier: "tr_TR")
        let cases: [(NumericFormatterStyle, NumberFormatter.Style)] = [
            (.decimal(locale: trLocale), .decimal),
            (.currency(.common(.TRY), locale: trLocale), .currency),
            (.percent(locale: trLocale), .percent),
            (.scientific(locale: trLocale), .scientific),
            (.spellOut(locale: trLocale), .spellOut),
            (.ordinal(locale: trLocale), .ordinal)
        ]

        for (style, expectedStyle) in cases {
            let formatter = NumberFormatter()
            style.configure(formatter)

            #expect(formatter.numberStyle == expectedStyle)
            #expect(formatter.locale.identifier == trLocale.identifier)
        }
    }
    
    @Test("NumericFormatterStyle cacheKey is unique and non-nil for non-custom styles.")
    func testNumericFormatterStyleCacheKey() {
        let styles: [NumericFormatterStyle] = [
            .decimal(),
            .decimal(maxFractionDigits: 3),
            .currency(.common(.USD)),
            .currency(.common(.EUR)),
            .percent(),
            .scientific(),
            .spellOut(),
            .ordinal()
        ]

        var keys = Set<String>()

        for style in styles {
            let key = style.cacheKey()
            #expect(key != nil)
            
            if let k = key {
                #expect(!keys.contains(k))
                keys.insert(k)
            }
        }

        let custom = NumericFormatterStyle.custom(formatter: NumberFormatter())
        #expect(custom.cacheKey() == nil)
    }
    
    // MARK: - CustomNumericFormatter Tests
    
    @Test("CustomNumericFormatter formats decimal numbers correctly.")
    func testCustomNumericFormatterDecimalFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(1234.5678, as: .decimal(maxFractionDigits: 1, locale: .init(identifier: "en_US")))
        
        #expect(result == "1,234.6")
    }

    @Test("CustomNumericFormatter formats currency correctly with ISO code.")
    func testCustomNumericFormatterCurrencyFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(9876.54, as: .currency(.common(.USD), locale: .init(identifier: "en_US")))
        
        #expect(result == "$9,876.54")
    }
    
    @Test("CustomNumericFormatter formats percent correctly.")
    func testCustomNumericFormatterPercentFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(0.25, as: .percent(locale: .init(identifier: "en_US")))
        
        #expect(result == "25%")
    }
    
    @Test("CustomNumericFormatter formats scientific notation correctly.")
    func testCustomNumericFormatterScientificFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(123456.0, as: .scientific(locale: .init(identifier: "en_US")))
        
        #expect(result == "1.23456E5")
    }
    
    @Test("CustomNumericFormatter formats numbers as words using spellOut.")
    func testCustomNumericFormatterSpellOutFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(42, as: .spellOut(locale: .init(identifier: "en_US")))
        
        #expect(result == "forty-two")
    }
    
    @Test("CustomNumericFormatter formats ordinal numbers correctly.")
    func testCustomNumericFormatterOrdinalFormatting() {
        let formatter = CustomNumericFormatter.mock()
        let result = formatter.format(3, as: .ordinal(locale: .init(identifier: "en_US")))
        
        #expect(result == "3rd")
    }

    @Test("CustomNumericFormatter uses exact external NumberFormatter in .custom.")
    func testCustomNumericFormatterCustomFormatterPassthrough() {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "💰"
        
        let style = NumericFormatterStyle.custom(formatter: numberFormatter)
        let result = CustomNumericFormatter.shared.format(123, as: style)
        
        #expect(result == "💰123.00")
    }
}
