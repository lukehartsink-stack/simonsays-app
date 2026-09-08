import SwiftUI

/// Shared multiple-choice engine behind the Knowledge Quiz and the Defect Diagnoser.
@Observable
final class MCQSession {
    let questions: [GameData.MCQ]
    var index = 0
    var chosen: [String: Int] = [:]
    var finished = false

    init(questions: [GameData.MCQ]) { self.questions = questions }

    var current: GameData.MCQ { questions[index] }
    var score: Int { questions.filter { chosen[$0.id] == $0.answer }.count }
    var answered: Bool { chosen[current.id] != nil }
    var pct: Int { questions.isEmpty ? 0 : Int((Double(score) / Double(questions.count) * 100).rounded()) }

    func choose(_ i: Int) {
        guard !answered else { return }
        chosen[current.id] = i
    }

    func next() {
        if index + 1 < questions.count { index += 1 } else { finished = true }
    }

    struct KindScore: Identifiable {
        let kind: String
        let correct: Int
        let total: Int
        var id: String { kind }
    }

    /// Per-category (or per-defect-type) breakdown, in first-seen order of `order` then any extras.
    func breakdown(order: [String]) -> [KindScore] {
        var totals: [String: (Int, Int)] = [:]
        for q in questions {
            var t = totals[q.kind] ?? (0, 0)
            t.1 += 1
            if chosen[q.id] == q.answer { t.0 += 1 }
            totals[q.kind] = t
        }
        let extras = totals.keys.filter { !order.contains($0) }.sorted()
        return (order + extras).compactMap { k in
            guard let t = totals[k] else { return nil }
            return KindScore(kind: k, correct: t.0, total: t.1)
        }
    }
}

private let optionLetters = ["A", "B", "C", "D"]

/// Question / answer / results flow. `header` draws whatever sits above the prompt
/// (a category eyebrow, or a defect illustration).
struct MCQSessionView<Header: View>: View {
    @Bindable var session: MCQSession
    let unitName: String               // "question" or "defect"
    let breakdownOrder: [String]
    let kindLabel: (String) -> String
    let bestKey: String
    @ViewBuilder let header: (GameData.MCQ) -> Header
    let onExit: () -> Void

    @AppStorage private var best: Int

    init(session: MCQSession, unitName: String, breakdownOrder: [String], kindLabel: @escaping (String) -> String,
         bestKey: String, @ViewBuilder header: @escaping (GameData.MCQ) -> Header, onExit: @escaping () -> Void) {
        self.session = session
        self.unitName = unitName
        self.breakdownOrder = breakdownOrder
        self.kindLabel = kindLabel
        self.bestKey = bestKey
        self.header = header
        self.onExit = onExit
        _best = AppStorage(wrappedValue: 0, bestKey)
    }

    var body: some View {
        if session.finished {
            results.onAppear { if session.score > best { best = session.score } }
        } else {
            question
        }
    }

    private var question: some View {
        let q = session.current
        let picked = session.chosen[q.id]
        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("\(unitName.capitalized) \(session.index + 1) of \(session.questions.count)")
                        .font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("Score \(session.score)").font(.caption.weight(.semibold)).foregroundStyle(Theme.accent)
                }
                ProgressView(value: Double(session.index), total: Double(session.questions.count))

                header(q)

                Text(q.prompt).font(.title3.weight(.semibold)).fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(q.options.indices, id: \.self) { i in
                        Button { session.choose(i) } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Text(optionLetters[i] + ".").font(.subheadline.weight(.bold))
                                Text(q.options[i]).multilineTextAlignment(.leading)
                                Spacer()
                                if let picked {
                                    if i == q.answer {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.green)
                                    } else if i == picked {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.red)
                                    }
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(background(for: i, picked: picked, answer: q.answer), in: RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.rule))
                        }
                        .buttonStyle(.plain)
                        .disabled(picked != nil)
                    }
                }

                if let picked {
                    Callout(q.why,
                            title: picked == q.answer ? "Correct" : "Not quite — the answer is \(optionLetters[q.answer])",
                            color: picked == q.answer ? Theme.green : Theme.red)
                    Button {
                        withAnimation { session.next() }
                    } label: {
                        Text(session.index + 1 < session.questions.count ? "Next \(unitName)" : "See results")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { Button("Quit", action: onExit) }
        }
    }

    private func background(for i: Int, picked: Int?, answer: Int) -> Color {
        guard let picked else { return Color(.secondarySystemGroupedBackground) }
        if i == answer { return Theme.green.opacity(0.12) }
        if i == picked { return Theme.red.opacity(0.12) }
        return Color(.secondarySystemGroupedBackground)
    }

    private var results: some View {
        let total = session.questions.count
        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Round complete")
                Text("\(session.score) / \(total)").font(.system(size: 52, weight: .bold)).foregroundStyle(Theme.accentDeep)
                Text("\(session.pct)% accuracy · best \(max(best, session.score)) / \(total)")
                    .font(.title3).foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Breakdown").font(.headline)
                    ForEach(session.breakdown(order: breakdownOrder)) { b in
                        HStack {
                            Text(kindLabel(b.kind)).font(.subheadline)
                            Spacer()
                            Text("\(b.correct) / \(b.total)").font(.subheadline.weight(.semibold))
                                .foregroundStyle(b.correct == b.total ? Theme.green : Theme.accent)
                        }
                        .padding(10)
                        .background(Theme.tint, in: RoundedRectangle(cornerRadius: 8))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Review").font(.headline)
                    ForEach(session.questions) { q in
                        let ok = session.chosen[q.id] == q.answer
                        DisclosureGroup {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Answer: \(q.options[q.answer])").font(.subheadline.weight(.semibold))
                                Text(q.why).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        } label: {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(ok ? Theme.green : Theme.red)
                                Text(q.prompt).font(.subheadline)
                            }
                        }
                    }
                }

                Button(action: onExit) {
                    Text("Play again").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
