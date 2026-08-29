import Foundation

struct ProductRange: Decodable, Identifiable {
    let label: String
    let products: [Product]
    var id: String { label }

    var categories: [String] {
        var seen: [String] = []
        for p in products where !seen.contains(p.c) { seen.append(p.c) }
        return seen
    }
}

struct Product: Decodable, Identifiable, Hashable {
    /// Name
    let n: String
    /// One-line tagline
    let t: String
    /// Category within its range
    let c: String
    /// Detail pairs — dilution/usage for chemicals, specification for tools
    let d: [[String]]
    /// Label for the detail block (nil → "Dilution & usage")
    let dl: String?
    /// Job areas (wash, decon, ppf, …)
    let u: [String]?
    /// Outbound links
    let L: [ProductLink]?
    /// Lower-cased full-text blob used for searching
    let b: String

    var id: String { n + "|" + c }
    var name: String { n }
    var tagline: String { t }
    var category: String { c }
    var detailLabel: String { dl ?? "Dilution & usage" }
    var details: [(String, String)] { d.map { ($0.first ?? "", $0.count > 1 ? $0[1] : "") } }
    var shopLink: URL? {
        guard let link = L?.first(where: { $0.u.hasPrefix("http") }) else { return nil }
        return URL(string: link.u)
    }
}

struct ProductLink: Decodable, Hashable {
    let t: String
    let u: String
    let cls: String?
}

enum JobArea: String, CaseIterable, Identifiable {
    case wash, decon, correction, ppf, protection, wheels, glass, interior, perfumers, equipment, machines
    var id: String { rawValue }
    var label: String {
        switch self {
        case .wash: return "Washing & pre-wash"
        case .decon: return "Decontamination"
        case .correction: return "Correction & paint prep"
        case .ppf: return "PPF installation"
        case .protection: return "Protection, wax & finish"
        case .wheels: return "Wheels, tyres & trim"
        case .glass: return "Glass"
        case .interior: return "Interior & upholstery"
        case .perfumers: return "Perfumers & air care"
        case .equipment: return "Cloths, pads & equipment"
        case .machines: return "Machines, pads & abrasives"
        }
    }
}
