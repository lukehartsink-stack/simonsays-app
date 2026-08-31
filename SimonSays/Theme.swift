import SwiftUI

/// Brand palette lifted from simonsays.coach's stylesheet — adaptive for light and dark mode.
enum Theme {
    // Brand blues
    static let accent       = Color(light: 0x2E75B6, dark: 0x5B9BD5)
    static let accentBright = Color(light: 0x4A90D9, dark: 0x6FAEE8)
    static let accentDeep   = Color(light: 0x1F4E79, dark: 0x8FBCE8)

    // Neutrals
    static let ink          = Color(light: 0x0E1116, dark: 0xE8EBEF)
    static let body         = Color(light: 0x2B3038, dark: 0xC7CDD5)
    static let muted        = Color(light: 0x697586, dark: 0x9AA4B2)
    static let faint        = Color(light: 0x9AA4B2, dark: 0x6B7684)
    static let rule         = Color(light: 0xE6E9EE, dark: 0x3A4048)
    static let tint         = Color(light: 0xF2F6FA, dark: 0x232B34)
    static let tintBorder   = Color(light: 0xDCE7F2, dark: 0x32404E)

    // Semantic accents (dark variants brightened so text/icons stay readable)
    static let green  = Color(light: 0x0F6E56, dark: 0x3FBF95)
    static let red    = Color(light: 0xA32D2D, dark: 0xE06B62)
    static let amber  = Color(light: 0xBA7517, dark: 0xDFA042)
    static let purple = Color(light: 0x533FAB, dark: 0x9F8FEF)
    static let rust   = Color(light: 0x993C1D, dark: 0xD97757)
    static let blue   = Color(light: 0x185FA5, dark: 0x5CA8F0)

    /// Chart palette used by the coverage calculator's roll layout.
    /// Mid-tones chosen to carry small white labels on both light and dark backgrounds.
    static let chart: [Color] = [
        Color(hex: 0x2D77BC), Color(hex: 0x168A6B), Color(hex: 0xCE8A28),
        Color(hex: 0xB04E2B), Color(hex: 0x6B57C9), Color(hex: 0x4E8420), Color(hex: 0xBF4040)
    ]

    static let contactEmail = "training@simonsays.coach"
    static let siteURL = URL(string: "https://simonsays.coach/")!
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    /// Dynamic colour that resolves per the current interface style.
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}

enum Format {
    /// Thousands-separated number with a fixed number of decimals (English locale, as on the site).
    static func number(_ value: Double, decimals: Int = 0) -> String {
        guard value.isFinite else { return "0" }
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_GB")
        f.numberStyle = .decimal
        f.minimumFractionDigits = decimals
        f.maximumFractionDigits = decimals
        return f.string(from: NSNumber(value: value)) ?? "0"
    }

    static func money(_ value: Double, symbol: String, decimals: Int = 0) -> String {
        symbol + number(value, decimals: decimals)
    }

    static func fixed(_ value: Double, _ decimals: Int = 2) -> String {
        String(format: "%.\(decimals)f", value)
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case eur = "€", usd = "$", gbp = "£", chf = "CHF"
    var id: String { rawValue }
    var label: String {
        switch self {
        case .eur: return "€ EUR"
        case .usd: return "$ USD"
        case .gbp: return "£ GBP"
        case .chf: return "CHF"
        }
    }
    var symbol: String { self == .chf ? "CHF " : rawValue }
}
