import SwiftUI

struct StudySetView: View {
    private let studySet = DataStore.shared.studySet
    @State private var selectedParts: Set<Int> = []
    @State private var count = 20
    @State private var shuffle = true
    @State private var session: QuizSession? = nil

    private var pool: [StudyQuestion] {
        studySet.questions.filter { selectedParts.isEmpty || selectedParts.contains($0.part) }
    }

    var body: some View {
        Group {
            if let session {
                QuizView(session: session) { self.session = nil }
            } else {
                setup
            }
        }
        .navigationTitle("Handbook Study Set")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var setup: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(studySet.subtitle)
                    Text("\(studySet.questions.count) multiple-choice questions on Parts 1–3. Each answer is marked straight away and points you to the handout to revisit.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }
            Section("Parts") {
                ForEach(studySet.parts) { part in
                    let n = studySet.questions.filter { $0.part == part.number }.count
                    Toggle(isOn: Binding(
                        get: { selectedParts.isEmpty || selectedParts.contains(part.number) },
                        set: { on in
                            if selectedParts.isEmpty { selectedParts = Set(studySet.parts.map(\.number)) }
                            if on { selectedParts.insert(part.number) } else { selectedParts.remove(part.number) }
                            if selectedParts.count == studySet.parts.count { selectedParts = [] }
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text("Part \(part.number) — \(part.name)")
                            Text("\(n) questions").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            Section("Session") {
                Stepper("Questions: \(min(count, pool.count))", value: $count, in: 5...max(5, pool.count), step: 5)
                Toggle("Shuffle questions", isOn: $shuffle)
            }
            Section {
                Button {
                    var qs = pool
                    if shuffle { qs.shuffle() }
                    session = QuizSession(questions: Array(qs.prefix(count)))
                } label: {
                    Label("Start", systemImage: "play.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(pool.isEmpty)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
        }
    }
}

@Observable
final class QuizSession {
    let questions: [StudyQuestion]
    var index = 0
    var chosen: [String: Int] = [:]
    var finished = false

    init(questions: [StudyQuestion]) { self.questions = questions }

    var current: StudyQuestion { questions[index] }
    var score: Int { questions.filter { chosen[$0.id] == $0.answer }.count }
    var answered: Bool { chosen[current.id] != nil }

    func choose(_ i: Int) {
        guard !answered else { return }
        chosen[current.id] = i
    }
    func next() {
        if index + 1 < questions.count { index += 1 } else { finished = true }
    }
    struct MissedHandout: Identifiable {
        let handout: String
        let title: String
        let count: Int
        var id: String { handout }
    }

    var missedByHandout: [MissedHandout] {
        var titles: [String: String] = [:]
        var counts: [String: Int] = [:]
        for q in questions where chosen[q.id] != q.answer {
            titles[q.handout] = q.handoutTitle
            counts[q.handout, default: 0] += 1
        }
        return counts.keys.sorted().map { MissedHandout(handout: $0, title: titles[$0] ?? "", count: counts[$0] ?? 0) }
    }
}

private let optionLetters = ["A", "B", "C", "D", "E", "F", "G", "H"]

struct QuizView: View {
    @Bindable var session: QuizSession
    let onExit: () -> Void

    var body: some View {
        if session.finished {
            results
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
                    Text("Question \(session.index + 1) of \(session.questions.count)").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("Score \(session.score)").font(.caption.weight(.semibold)).foregroundStyle(Theme.accent)
                }
                ProgressView(value: Double(session.index), total: Double(session.questions.count))
                Eyebrow("Part \(q.part) · Handout \(q.handout) — \(q.handoutTitle)")
                Text(q.q).font(.title3.weight(.semibold)).fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(q.options.indices, id: \.self) { i in
                        Button { session.choose(i) } label: {
                            HStack(alignment: .top, spacing: 10) {
                                Text((i < optionLetters.count ? optionLetters[i] : "\(i + 1)") + ".")
                                    .font(.subheadline.weight(.bold))
                                Text(q.options[i]).multilineTextAlignment(.leading)
                                Spacer()
                                if let picked {
                                    if i == q.answer {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Color(hex: 0x0F6E56))
                                    } else if i == picked {
                                        Image(systemName: "xmark.circle.fill").foregroundStyle(Color(hex: 0xA32D2D))
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
                            title: picked == q.answer ? "Correct" : "Not quite — the answer is \(q.answer < optionLetters.count ? optionLetters[q.answer] : "\(q.answer + 1)")",
                            color: picked == q.answer ? Color(hex: 0x0F6E56) : Color(hex: 0xA32D2D))
                    Button {
                        withAnimation { session.next() }
                    } label: {
                        Text(session.index + 1 < session.questions.count ? "Next question" : "See results").frame(maxWidth: .infinity)
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
        if i == answer { return Color(hex: 0x0F6E56).opacity(0.12) }
        if i == picked { return Color(hex: 0xA32D2D).opacity(0.12) }
        return Color(.secondarySystemGroupedBackground)
    }

    private var results: some View {
        let total = session.questions.count
        let pct = total > 0 ? Int((Double(session.score) / Double(total) * 100).rounded()) : 0
        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Results")
                Text("\(session.score) / \(total)").font(.system(size: 52, weight: .bold)).foregroundStyle(Theme.accentDeep)
                Text("\(pct)% correct").font(.title3).foregroundStyle(.secondary)

                let missed = session.missedByHandout
                if missed.isEmpty {
                    Callout("Full marks. Nothing to revisit from this set.", title: "Well done", color: Color(hex: 0x0F6E56))
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Handouts to revisit").font(.headline)
                        ForEach(missed) { m in
                            HStack(alignment: .top, spacing: 10) {
                                Text(m.handout).font(.subheadline.weight(.bold)).foregroundStyle(Theme.accent).frame(width: 36, alignment: .leading)
                                Text(m.title).font(.subheadline)
                                Spacer()
                                Text("\(m.count) missed").font(.caption).foregroundStyle(.secondary)
                            }
                            .padding(10)
                            .background(Theme.tint, in: RoundedRectangle(cornerRadius: 8))
                        }
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
                                    .foregroundStyle(ok ? Color(hex: 0x0F6E56) : Color(hex: 0xA32D2D))
                                Text(q.q).font(.subheadline)
                            }
                        }
                    }
                }

                Button(action: onExit) {
                    Text("Back to setup").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack { StudySetView() }
}
