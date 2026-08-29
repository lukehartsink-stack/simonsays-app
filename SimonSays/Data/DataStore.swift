import Foundation

/// Loads the bundled JSON content (exported from simonsays.coach) once and shares it app-wide.
final class DataStore {
    static let shared = DataStore()

    let faq: FAQData
    let studySet: StudySet
    let productRanges: [ProductRange]

    private init() {
        faq = DataStore.load("faqs", fallback: FAQData(title: "PPF Installation FAQ", subtitle: "", categories: [], audiences: [], faqs: []))
        studySet = DataStore.load("studyset", fallback: StudySet(title: "Study Set", subtitle: "", parts: [], questions: []))
        productRanges = DataStore.load("products", fallback: [])
    }

    var allProducts: [(range: String, product: Product)] {
        productRanges.flatMap { r in r.products.map { (r.label, $0) } }
    }

    private static func load<T: Decodable>(_ name: String, fallback: T) -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            assertionFailure("Missing bundled resource \(name).json")
            return fallback
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            assertionFailure("Failed to decode \(name).json: \(error)")
            return fallback
        }
    }
}
