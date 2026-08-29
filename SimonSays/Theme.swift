import SwiftUI

/// Brand palette lifted from simonsays.coach's stylesheet.
enum Theme {
    static let accent       = Color(hex: 0x2E75B6)
    static let accentBright = Color(hex: 0x4A90D9)
    static let accentDeep   = Color(hex: 0x1F4E79)
    static let ink          = Color(hex: 0x0E1116)
    static let body         = Color(hex: 0x2B3038)
    static let muted        = Color(hex: 0x697586)
    static let faint        = Color(hex: 0x9AA4B2)
    static let rule         = Color(hex: 0xE6E9EE)
    static let tint         = Color(hex: 0xF2F6FA)
    static let tintBorder   = Color(hex: 0xDCE7F2)

    /// Chart palette used by the coverage calculator's roll layout.
    static let chart: [Color] = [
        Color(hex: 0x185FA5), Color(hex: 0x0F6E56), Color(hex: 0xBA7517),
        Color(hex: 0x993C1D), Color(hex: 0x533FAB), Color(hex: 0x3B6D11), Color(hex: 0xA32D2D)
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
