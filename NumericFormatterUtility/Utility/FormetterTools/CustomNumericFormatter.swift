//
//  CustomNumericFormatter.swift
//  NumericFormatterUtility
//
//  Created by Tahir Anil Oghan on 28.07.2025.
//

import Foundation

// MARK: - Protocol
/// A protocol that defines a numeric value formatter.
public protocol NumericFormatter {

    /// Formats the given `NSNumber` into a string representation.
    ///
    /// - Parameters:
    ///   - num: The `NSNumber` value to be formatted.
    ///   - style: The desired formatting style.
    /// - Returns: A formatted string, or `nil` if formatting fails.
    func format(_ num: NSNumber, as style: NumericFormatterStyle) -> String?
}

// MARK: - Protocol Extension (Convenience Overloads)
extension NumericFormatter {

    /// Formats the given `Int` value into a string representation.
    ///
    /// - Parameters:
    ///   - int: The integer value to be formatted.
    ///   - style: The desired formatting style.
    /// - Returns: A formatted string, or `nil` if formatting fails.
    public func format(_ int: Int, as style: NumericFormatterStyle) -> String? {
        format(NSNumber(value: int), as: style)
    }

    /// Formats the given `Double` value into a string representation.
    ///
    /// - Parameters:
    ///   - double: The double-precision floating-point value to be formatted.
    ///   - style: The desired formatting style.
    /// - Returns: A formatted string, or `nil` if formatting fails.
    public func format(_ double: Double, as style: NumericFormatterStyle) -> String? {
        format(NSNumber(value: double), as: style)
    }

    /// Formats the given `Float` value into a string representation.
    ///
    /// - Parameters:
    ///   - float: The single-precision floating-point value to be formatted.
    ///   - style: The desired formatting style.
    /// - Returns: A formatted string, or `nil` if formatting fails.
    public func format(_ float: Float, as style: NumericFormatterStyle) -> String? {
        format(NSNumber(value: float), as: style)
    }
}

// MARK: - Helpers
/// Supported ISO 4217 currency codes. Used to ensure type safety and prevent invalid currency strings.
public enum NumericFormatterISO4217: String, CaseIterable {
    case AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN, BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BRL, BSD, BTN, BWP, BYN, BZD, CAD, CDF, CHF, CLP, CNY, COP, CRC, CUC, CUP, CVE, CZK, DJF, DKK, DOP, DZD, EGP, ERN, ETB, EUR, FJD, FKP, GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD, HKD, HNL, HRK, HTG, HUF, IDR, ILS, INR, IQD, IRR, ISK, JMD, JOD, JPY, KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT, LAK, LBP, LKR, LRD, LSL, LYD, MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MYR, MZN, NAD, NGN, NIO, NOK, NPR, NZD, OMR, PAB, PEN, PGK, PHP, PKR, PLN, PYG, QAR, RON, RSD, RUB, RWF, SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLE, SLL, SOS, SRD, SSP, STN, SYP, SZL, THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS, UAH, UGX, USD, UYU, UZS, VEF, VES, VND, VUV, WST, XAF, XCD, XCG, XOF, XPF, YER, ZAR, ZMW, ZWG
}

/// Represents a currency configuration for numeric formatting.
/// Supports type-safe common ISO 4217 codes and custom currency codes.
public enum NumericFormatterCurrency {
    case common(NumericFormatterISO4217)
    case custom(String)
    
    /// Returns the code as String.
    internal var description: String {
        switch self {
            case .common(let code): return code.rawValue
            case .custom(let code): return code
        }
    }
}

/// Defines a set of number formatting styles for numeric formatting.
public enum NumericFormatterStyle {
    
    /// Decimal style with configurable maximum fraction digits.
    ///
    /// - Parameters:
    ///   - maxFractionDigits: The maximum number of digits after the decimal point. Default is `2`.
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case decimal(
        maxFractionDigits: Int = 2,
        locale: Locale = .current
    )

    /// Currency style with an optional ISO 4217 currency code.
    ///
    /// - Parameters:
    ///   - code: The currency code to use (e.g., `USD`, `EUR`). Defaults to the current locale's currency.
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case currency(
        _ code: NumericFormatterCurrency = .custom(Locale.current.currency?.identifier ?? "USD"),
        locale: Locale = .current
    )

    /// Percent style for formatting values like `50%`.
    ///
    /// - Parameters:
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case percent(locale: Locale = .current)

    /// Scientific notation style (e.g., `1.23E4`).
    ///
    /// - Parameters:
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case scientific(locale: Locale = .current)

    /// Spell-out style (e.g., `123` becomes "one hundred twenty-three").
    ///
    /// - Parameters:
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case spellOut(locale: Locale = .current)

    /// Localized ordinal strings (e.g., `"1st"`, `"2nd"`, `"3rd"`).
    ///
    /// - Parameters:
    ///   - locale: The locale to use for formatting. Default is `.current`.
    case ordinal(locale: Locale = .current)

    /// Uses a custom externally configured `NumberFormatter`.
    ///
    /// This rule bypasses internal configuration logic.
    case custom(formatter: NumberFormatter)
    
    /// Configures the provided `NumberFormatter` according to the current style.
    ///
    /// - Parameters:
    ///   - formatter: The `NumberFormatter` instance to configure.
    internal func configure(_ formatter: NumberFormatter) {
        switch self {
            case .decimal(let maxFractionDigits, let locale):
                formatter.locale = locale
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = maxFractionDigits
                
            case .currency(let code, let locale):
                formatter.locale = locale
                formatter.numberStyle = .currency
                formatter.currencyCode = code.description
                
            case .percent(let locale):
                formatter.locale = locale
                formatter.numberStyle = .percent
                
            case .scientific(let locale):
                formatter.locale = locale
                formatter.numberStyle = .scientific
                
            case .spellOut(let locale):
                formatter.locale = locale
                formatter.numberStyle = .spellOut
                
            case .ordinal(let locale):
                formatter.locale = locale
                formatter.numberStyle = .ordinal
                
            case .custom:
                // Do nothing; formatter is already configured
                break
        }
    }
    
    /// Returns a unique cache key representing the current style.
    ///
    /// - Returns: A string that can be used to cache formatters per style configuration.
    internal func cacheKey() -> String? {
        switch self {
            case .decimal(let maxFractionDigits, let locale):
                return "decimal:\(maxFractionDigits):\(locale.identifier)"
                
            case .currency(let code, let locale):
                return "currency:\(code.description):\(locale.identifier)"
                
            case .percent(let locale):
                return "percent:\(locale.identifier)"
                
            case .scientific(let locale):
                return "scientific:\(locale.identifier)"
                
            case .spellOut(let locale):
                return "spellOut:\(locale.identifier)"
                
            case .ordinal(let locale):
                return "ordinal:\(locale.identifier)"
                
            case .custom:
                return nil
        }
    }
}

// MARK: - Implementation
/// Implementation of `NumericFormatter` that formats numeric values using predefined styles.
///
/// This formatter supports decimal, currency, percent, scientific, spell-out, compact, ordinal, and custom styles.
/// It uses internal caching for performance and enforces a singleton-based access pattern.
internal final class CustomNumericFormatter {
    
    /// Singleton instance.
    internal static let shared: CustomNumericFormatter = CustomNumericFormatter()
    
    /// Formatter cache for reusable configurations.
    private var cache: NSCache<NSString, NumberFormatter> = .init()
    
    /// Secured initializer to enforce `.shared` usage.
    private init() { }
}

// MARK: - Private Methods
extension CustomNumericFormatter {
    
    /// Returns a cached or newly configured `NumberFormatter` for the given style.
    ///
    /// - Parameters:
    ///   - style: The formatting style to apply.
    /// - Returns: A `NumberFormatter` instance configured for the style.
    private func formatter(for style: NumericFormatterStyle) -> NumberFormatter {
        switch style {
            case .custom(let externalFormatter):
                return externalFormatter
            default:
                // This key will not be nil if it is not .custom style.
                let key = NSString(string: style.cacheKey()!)
                
                // If cached return it.
                if let cached = cache.object(forKey: key) { return cached }
                
                let formatter = NumberFormatter()
                style.configure(formatter)
                cache.setObject(formatter, forKey: key)
                return formatter
        }
    }
}

// MARK: - Protocol Conformance
extension CustomNumericFormatter: NumericFormatter {

    internal func format(_ num: NSNumber, as style: NumericFormatterStyle) -> String? {
        let formatter = formatter(for: style)
        return formatter.string(from: num)
    }
}

// MARK: - Factory Initializer
#if DEBUG
extension CustomNumericFormatter {
    
    /// Returns a new, isolated instance of `CustomNumericFormatter` for testing purposes.
    ///
    /// - Returns: A fresh `CustomNumericFormatter` instance, separate from the shared singleton.
    ///
    /// Use this method in unit tests.
    internal static func mock() -> CustomNumericFormatter {
        CustomNumericFormatter()
    }
}
#endif
