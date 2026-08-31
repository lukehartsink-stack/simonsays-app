import SwiftUI

// MARK: - App-wide navigation state

/// Shared tab selection so any screen can jump to another tab (e.g. re-run a recent search).
final class AppState: ObservableObject {
    static let shared = AppState()
    @Published var selectedTab = 0
    @Published var pendingSearch: String? = nil

    func openSearch(_ query: String) {
        pendingSearch = query
        selectedTab = 0
    }
}

// MARK: - Profile

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case detailer, installer, salesperson, shopOwner, trainee, other
    var id: String { rawValue }
    var label: String {
        switch self {
        case .detailer: return "Detailer"
        case .installer: return "PPF Installer"
        case .salesperson: return "Salesperson"
        case .shopOwner: return "Shop Owner"
        case .trainee: return "Trainee"
        case .other: return "Other"
        }
    }
    var icon: String {
        switch self {
        case .detailer: return "sparkles"
        case .installer: return "car.fill"
        case .salesperson: return "person.2.fill"
        case .shopOwner: return "building.2.fill"
        case .trainee: return "graduationcap.fill"
        case .other: return "person.fill"
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var role: UserRole
    var shopName: String

    var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        return parts.map { String($0.prefix(1)).uppercased() }.joined()
    }
}

// MARK: - Quiz history

struct PartScore: Codable {
    var correct: Int
    var total: Int
}

struct QuizRecord: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let score: Int
    let total: Int
    let perPart: [Int: PartScore]

    var pct: Int { total > 0 ? Int((Double(score) / Double(total) * 100).rounded()) : 0 }
}

// MARK: - Store

/// Persists the profile, quiz history, FAQ bookmarks and missed-question pool in UserDefaults.
final class ProfileStore: ObservableObject {
    static let shared = ProfileStore()

    @Published var profile: UserProfile? { didSet { save(profile, key: "userProfile") } }
    @Published var records: [QuizRecord] { didSet { save(records, key: "quizRecords") } }
    @Published var bookmarks: Set<String> { didSet { save(Array(bookmarks), key: "faqBookmarks") } }
    @Published var missed: Set<String> { didSet { save(Array(missed), key: "missedQuestions") } }

    private init() {
        profile = Self.load(UserProfile.self, key: "userProfile")
        records = Self.load([QuizRecord].self, key: "quizRecords") ?? []
        bookmarks = Set(Self.load([String].self, key: "faqBookmarks") ?? [])
        missed = Set(Self.load([String].self, key: "missedQuestions") ?? [])
    }

    // MARK: Quiz results

    /// Record a finished session once: score history, per-part mastery, and the missed-question pool.
    func record(session: QuizSession) {
        guard session.finished, !session.recorded else { return }
        session.recorded = true

        var perPart: [Int: PartScore] = [:]
        for q in session.questions {
            var s = perPart[q.part] ?? PartScore(correct: 0, total: 0)
            s.total += 1
            let ok = session.chosen[q.id] == q.answer
            if ok { s.correct += 1 }
            perPart[q.part] = s
            if ok { missed.remove(q.id) } else { missed.insert(q.id) }
        }
        records.append(QuizRecord(date: Date(), score: session.score, total: session.questions.count, perPart: perPart))
    }

    var recentRecords: [QuizRecord] { records.sorted { $0.date > $1.date } }
    var testsTaken: Int { records.count }
    var bestPct: Int { records.map(\.pct).max() ?? 0 }
    var averagePct: Int {
        guard !records.isEmpty else { return 0 }
        return Int((Double(records.map(\.pct).reduce(0, +)) / Double(records.count)).rounded())
    }

    /// All-time mastery for one handbook part, or nil if never tested.
    func mastery(part: Int) -> Double? {
        var correct = 0, total = 0
        for r in records {
            if let s = r.perPart[part] { correct += s.correct; total += s.total }
        }
        guard total > 0 else { return nil }
        return Double(correct) / Double(total)
    }

    var missedQuestions: [StudyQuestion] {
        DataStore.shared.studySet.questions.filter { missed.contains($0.id) }
    }

    // MARK: Bookmarks

    func isBookmarked(_ faqID: String) -> Bool { bookmarks.contains("faq-\(faqID)") }

    func toggleBookmark(_ faqID: String) {
        let key = "faq-\(faqID)"
        if bookmarks.contains(key) { bookmarks.remove(key) } else { bookmarks.insert(key) }
    }

    var bookmarkedFAQs: [FAQItem] {
        DataStore.shared.faq.faqs.filter { bookmarks.contains("faq-\($0.id)") }
    }

    // MARK: Persistence

    private func save<T: Encodable>(_ value: T?, key: String) {
        guard let value, let data = try? JSONEncoder().encode(value) else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
