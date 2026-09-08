import SwiftUI

/// The Tests tab: study set, progress dashboard, missed-question review, and quiz games.
struct TestsView: View {
    @ObservedObject private var store = ProfileStore.shared
    private let studySet = DataStore.shared.studySet

    var body: some View {
        NavigationStack {
            List {
                if store.testsTaken > 0 {
                    progressSection
                }

                if !store.missedQuestions.isEmpty {
                    Section {
                        NavigationLink {
                            MissedReviewView(questions: store.missedQuestions.shuffled())
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .font(.title2).foregroundStyle(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Theme.iconDeep, in: RoundedRectangle(cornerRadius: 10))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Review missed questions").font(.headline)
                                    Text("\(store.missedQuestions.count) to clear — answer them right and they drop off the list")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Take a test") {
                    NavCard(badge: "\(studySet.questions.count) questions", title: "Handbook Study Set",
                            text: "Multiple-choice questions on Parts 1–3. Marks your answers and points you to the handouts to revisit.",
                            systemImage: "checkmark.circle.fill") { StudySetView() }
                    NavCard(badge: "20 questions", title: "PPF Knowledge Quiz",
                            text: "Twenty randomised questions across Materials, Application, Defects and Business.",
                            systemImage: "graduationcap.fill") {
                        KnowledgeQuizView()
                    }
                    NavCard(badge: "9 tools", title: "Fun & Games",
                            text: "Drills, demos, quizzes, and games — from the self-heal demo to the panel-sequence puzzle.",
                            systemImage: "gamecontroller.fill") { FunAndGamesView() }
                }

                if !store.recentRecords.isEmpty {
                    Section("Recent results") {
                        ForEach(store.recentRecords.prefix(8)) { r in
                            HStack {
                                scoreBadge(r.pct)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(r.score) / \(r.total) correct").font(.body)
                                    Text(r.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(parts(of: r)).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tests")
        }
    }

    private var progressSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MetricCard(label: "Tests taken", value: "\(store.testsTaken)")
                MetricCard(label: "Average", value: "\(store.averagePct)%")
                MetricCard(label: "Best", value: "\(store.bestPct)%")
            }
            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            .listRowBackground(Color.clear)

            VStack(alignment: .leading, spacing: 10) {
                Text("Mastery by part").font(.subheadline.weight(.semibold))
                ForEach(studySet.parts) { part in
                    masteryRow(part)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Your progress")
        }
    }

    private func masteryRow(_ part: StudyPart) -> some View {
        let m = store.mastery(part: part.number)
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Part \(part.number) — \(part.name)").font(.caption)
                Spacer()
                Text(m.map { "\(Int(($0 * 100).rounded()))%" } ?? "Not tested yet")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(m == nil ? Color.secondary : color(for: m!))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.rule)
                    if let m {
                        Capsule().fill(color(for: m)).frame(width: max(6, geo.size.width * m))
                    }
                }
            }
            .frame(height: 6)
        }
    }

    private func color(for mastery: Double) -> Color {
        mastery >= 0.8 ? Theme.green : mastery >= 0.5 ? Theme.amber : Theme.red
    }

    private func scoreBadge(_ pct: Int) -> some View {
        Text("\(pct)%")
            .font(.subheadline.weight(.bold))
            .frame(width: 48, height: 34)
            .background(color(for: Double(pct) / 100).opacity(0.14), in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(color(for: Double(pct) / 100))
    }

    private func parts(of r: QuizRecord) -> String {
        let ps = r.perPart.keys.sorted()
        guard !ps.isEmpty else { return "" }
        return "Part " + ps.map(String.init).joined(separator: ", ")
    }
}

/// Runs a quiz over the questions the user previously got wrong.
struct MissedReviewView: View {
    @State private var session: QuizSession
    @Environment(\.dismiss) private var dismiss

    init(questions: [StudyQuestion]) {
        _session = State(initialValue: QuizSession(questions: questions))
    }

    var body: some View {
        QuizView(session: session) { dismiss() }
            .navigationTitle("Review Missed")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TestsView()
}
