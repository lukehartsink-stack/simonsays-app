import SwiftUI

/// What kind of thing a search hit is. Drives the icon, colour and grouping in results.
enum SearchKind: String, CaseIterable, Identifiable {
    case faq, product, tool, handbook, guide

    var id: String { rawValue }

    var label: String {
        switch self {
        case .faq: return "FAQ answers"
        case .product: return "Products"
        case .tool: return "Tools"
        case .handbook: return "Handbook"
        case .guide: return "Guides"
        }
    }

    var icon: String {
        switch self {
        case .faq: return "questionmark.bubble.fill"
        case .product: return "shippingbox.fill"
        case .tool: return "wrench.and.screwdriver.fill"
        case .handbook: return "book.closed.fill"
        case .guide: return "doc.text.fill"
        }
    }

    var color: Color {
        switch self {
        case .faq: return Color(hex: 0x533FAB)
        case .product: return Color(hex: 0x0F6E56)
        case .tool: return Color(hex: 0xBA7517)
        case .handbook: return Theme.accent
        case .guide: return Color(hex: 0x993C1D)
        }
    }
}

/// Scope picker under the search bar.
enum SearchScope: String, CaseIterable, Identifiable {
    case all, faq, products, tools, handbook
    var id: String { rawValue }
    var label: String {
        switch self {
        case .all: return "All"
        case .faq: return "FAQ"
        case .products: return "Products"
        case .tools: return "Tools"
        case .handbook: return "Handbook"
        }
    }
    func includes(_ kind: SearchKind) -> Bool {
        switch self {
        case .all: return true
        case .faq: return kind == .faq
        case .products: return kind == .product
        case .tools: return kind == .tool
        case .handbook: return kind == .handbook || kind == .guide
        }
    }
}

/// Where a search hit navigates to.
enum SearchDestination {
    case faq(FAQItem)
    case product(Product, range: String)
    case handbook
    case coverageCalculator
    case hourlyRateCalculator
    case studySet
    case funAndGames
    case liftingEdges
    case quoteGuide
    case carOwnerGuide
    case productFinder
    case shoppingList
    case faqList
}

struct SearchEntry: Identifiable {
    let id: String
    let kind: SearchKind
    let title: String
    let subtitle: String
    /// Lower-cased text used for matching (title + subtitle + body + tags).
    let haystack: String
    let destination: SearchDestination
}

/// Builds one flat, searchable index over everything bundled in the app.
final class SearchIndex {
    static let shared = SearchIndex()

    let entries: [SearchEntry]

    private init() {
        let store = DataStore.shared
        var out: [SearchEntry] = []

        // FAQ
        let catName = Dictionary(uniqueKeysWithValues: store.faq.categories.map { ($0.id, $0.name) })
        for f in store.faq.faqs {
            out.append(SearchEntry(
                id: "faq-\(f.id)", kind: .faq, title: f.q,
                subtitle: catName[f.category] ?? f.category,
                haystack: (f.q + " " + f.a + " " + (f.tags ?? []).joined(separator: " ") + " " + (catName[f.category] ?? "")).lowercased(),
                destination: .faq(f)))
        }

        // Products
        for r in store.productRanges {
            for p in r.products {
                let hay = p.b.isEmpty ? (p.n + " " + p.t + " " + p.c + " " + r.label).lowercased() : (p.b + " " + r.label.lowercased())
                out.append(SearchEntry(
                    id: "product-\(r.label)-\(p.id)", kind: .product, title: p.name,
                    subtitle: "\(r.label) · \(p.category)",
                    haystack: hay,
                    destination: .product(p, range: r.label)))
            }
        }

        // Tools
        let tools: [(String, String, String, SearchDestination)] = [
            ("PPF Coverage Calculator", "How much film a job consumes, with nesting", "coverage calculator film roll width trim safety margin nesting offcut cost per m2 metres order material quote", .coverageCalculator),
            ("Hourly Rate Calculator", "A defensible rate from your real cost base", "hourly rate calculator wage overheads fixed variable costs future fund profit margin billable hours price pricing business", .hourlyRateCalculator),
            ("Handbook Study Set", "88 multiple-choice questions on Parts 1–3", "study set quiz test questions exam revision learn training handbook multiple choice", .studySet),
            ("Fun & Games", "Drills, demos, quizzes and games", "games drills demo quiz stretch lab heat tack self heal spot the defect diagnoser panel sequence puzzle checklist", .funAndGames),
            ("Detailing Product Finder", "332 products across 7 ranges", "product finder labocosmetica mafra maniac line rupes flex micrum kovax polish compound pad shampoo dilution", .productFinder),
            ("PPF Shopping List", "The kit Simon uses on the bench", "shopping list kit tools squeegee knife blade magnet sprayer slip solution tack booster amazon glansz buy", .shoppingList),
            ("PPF Installation FAQ", "100 questions, filter by topic", "faq questions answers installers car owners", .faqList)
        ]
        for (i, t) in tools.enumerated() {
            out.append(SearchEntry(id: "tool-\(i)", kind: .tool, title: t.0, subtitle: t.1,
                                   haystack: (t.0 + " " + t.1 + " " + t.2).lowercased(), destination: t.3))
        }

        // Handbook parts
        let parts: [(String, String)] = [
            ("Part 1 — Foundations", "PPF materials, adhesives, matt vs gloss, the physics of adhesion, TPU TPH PVC top coat self-healing Van der Waals"),
            ("Part 2 — Installation Workflow", "Intake, prep, install, QC. Panel-stretch and lifting-edges references, SOP squeegee slip solution post-heat"),
            ("Part 3 — Customer Lifecycle", "Handover, customer expectations, warranty law UK EU, claim-handling playbook, aftercare"),
            ("Part 4 — Reference Forms", "Vehicle intake form, QC sign-off, customer care card, templates"),
            ("Part 5 — Business Operations", "Finance, hourly rates, hiring, marketing, Veblen positioning, quoting, invoicing, complaints"),
            ("Part 6 — Protecting the Business", "Insurance, damage to a customer's car, booking terms, cancellations, warranty claim cost, unpaid invoices, customer data GDPR")
        ]
        for (i, p) in parts.enumerated() {
            out.append(SearchEntry(id: "handbook-\(i)", kind: .handbook, title: p.0, subtitle: "Handbook · 43 handouts in six parts",
                                   haystack: (p.0 + " " + p.1).lowercased(), destination: .handbook))
        }

        // Guides / previews
        let guides: [(String, String, String, SearchDestination)] = [
            ("2.9 Lifting Edges — Decision Tree", "Six questions, four root causes", "lifting edges edge lift peel decision tree stretch surface prep activation post heat slip technique bubbles cloudy bumper mirror relief cut diagnose", .liftingEdges),
            ("PPF Guide for Car Owners", "What PPF costs and how to choose an installer", "cost price quote worth it how long does it take installer choose warranty full front full body wrap car owner customer", .carOwnerGuide),
            ("Quote Calculator User Guide", "Building a quote with the Profilm template", "quote calculator excel profilm template discount vat dashboard installer worksheet customer linear metres", .quoteGuide)
        ]
        for (i, g) in guides.enumerated() {
            out.append(SearchEntry(id: "guide-\(i)", kind: .guide, title: g.0, subtitle: g.1,
                                   haystack: (g.0 + " " + g.1 + " " + g.2).lowercased(), destination: g.3))
        }

        entries = out
    }

    struct Group: Identifiable {
        let kind: SearchKind
        let hits: [SearchEntry]
        var id: String { kind.rawValue }
    }

    /// Ranked search. Every term must appear somewhere; title hits rank higher.
    func search(_ query: String, scope: SearchScope = .all, limitPerKind: Int = 8) -> [Group] {
        let terms = query.lowercased().split(whereSeparator: { $0 == " " || $0 == "," }).map(String.init).filter { $0.count > 1 || Int($0) != nil }
        guard !terms.isEmpty else { return [] }

        var scored: [(SearchEntry, Int)] = []
        for e in entries where scope.includes(e.kind) {
            let title = e.title.lowercased()
            var score = 0
            var allMatch = true
            for t in terms {
                if title.contains(t) { score += 4 }
                else if e.subtitle.lowercased().contains(t) { score += 2 }
                else if e.haystack.contains(t) { score += 1 }
                else { allMatch = false; break }
            }
            if allMatch {
                if title.hasPrefix(terms[0]) { score += 2 }
                scored.append((e, score))
            }
        }

        var grouped: [SearchKind: [(SearchEntry, Int)]] = [:]
        for s in scored { grouped[s.0.kind, default: []].append(s) }

        return SearchKind.allCases.compactMap { kind in
            guard let list = grouped[kind], !list.isEmpty else { return nil }
            let top = list.sorted { $0.1 > $1.1 }.prefix(limitPerKind).map { $0.0 }
            return Group(kind: kind, hits: Array(top))
        }
    }
}
