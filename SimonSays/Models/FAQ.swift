import Foundation

struct FAQData: Decodable {
    let title: String
    let subtitle: String
    let categories: [FAQCategory]
    let audiences: [FAQAudience]
    let faqs: [FAQItem]
}

struct FAQCategory: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
}

struct FAQAudience: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
}

struct FAQItem: Decodable, Identifiable, Hashable {
    let id: String
    let category: String
    let audience: String
    let q: String
    let a: String
    let handoutRefs: [HandoutRef]?
    let sources: [FAQSource]?
    let tags: [String]?

    var searchBlob: String {
        (q + " " + a + " " + (tags ?? []).joined(separator: " ")).lowercased()
    }
}

struct HandoutRef: Decodable, Hashable {
    let ref: String
    let title: String
}

struct FAQSource: Decodable, Hashable {
    let label: String
    let url: String?
}
