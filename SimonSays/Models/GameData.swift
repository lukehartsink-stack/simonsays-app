import Foundation

/// The Fun & Games content banks, copied from simonsays.coach by `tools/sync-content.js`.
/// Each bank is a plain text file in Resources/: one entry per line, fields separated by " | ".
enum GameData {
    struct Drill: Identifiable, Hashable {
        let title: String
        let difficulty: String   // Beginner / Intermediate / Advanced
        let minutes: Int
        let desc: String
        var id: String { title }
    }

    struct ChecklistItem: Identifiable, Hashable {
        let category: String
        let mandatory: Bool
        let text: String
        var id: String { category + "|" + text }
    }

    /// One multiple-choice question. `kind` is the quiz category or the diagnoser's defect type.
    struct MCQ: Identifiable, Hashable {
        let kind: String
        let prompt: String
        let options: [String]
        let answer: Int
        let why: String
        var id: String { kind + "|" + prompt }
    }

    static let checklistCategories = ["Environment", "Vehicle", "Surface", "Tools", "Installer"]
    static let quizCategories = ["Materials", "Application", "Defects", "Business"]

    static let drills: [Drill] = rows("drills").compactMap { (f: [String]) -> Drill? in
        guard f.count == 4, let m = Int(f[2]) else { return nil }
        return Drill(title: f[0], difficulty: f[1], minutes: m, desc: f[3])
    }

    static let checklist: [ChecklistItem] = rows("checklist").compactMap { (f: [String]) -> ChecklistItem? in
        guard f.count == 3 else { return nil }
        return ChecklistItem(category: f[0], mandatory: f[1].lowercased() == "yes", text: f[2])
    }

    static let diagnoser: [MCQ] = rows("diagnoser").compactMap(mcq)
    static let quiz: [MCQ] = rows("quiz").compactMap(mcq)

    /// Canonical install order, first to last.
    static let panels: [String] = lines("panels")

    // MARK: Parsing

    private static func mcq(_ f: [String]) -> MCQ? {
        // Kind | Prompt | A | B | C | D | Correct letter | Explanation
        guard f.count == 8 else { return nil }
        let letters = ["A", "B", "C", "D"]
        guard let answer = letters.firstIndex(of: f[6].uppercased()) else { return nil }
        return MCQ(kind: f[0], prompt: f[1], options: Array(f[2...5]), answer: answer, why: f[7])
    }

    private static func rows(_ name: String) -> [[String]] {
        lines(name).map { $0.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces) } }
    }

    private static func lines(_ name: String) -> [String] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            assertionFailure("Missing bundled resource \(name).txt")
            return []
        }
        return text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !$0.hasPrefix("//") }
    }
}
