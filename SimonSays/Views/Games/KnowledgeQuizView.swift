import SwiftUI

/// Twenty questions, no clock: five drawn at random from each of the four categories.
struct KnowledgeQuizView: View {
    @State private var session: MCQSession? = nil
    @AppStorage("quiz.best") private var best = 0

    private var bank: [GameData.MCQ] { GameData.quiz }

    var body: some View {
        Group {
            if let session {
                MCQSessionView(session: session, unitName: "question", breakdownOrder: GameData.quizCategories,
                               kindLabel: { $0 }, bestKey: "quiz.best") { q in
                    Eyebrow(q.kind)
                } onExit: { self.session = nil }
            } else {
                intro
            }
        }
        .navigationTitle("PPF Knowledge Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var intro: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Self-test")
                Text("Twenty questions, no clock").font(.largeTitle.weight(.bold))
                Text("Five questions are drawn at random from each of four categories: Materials, Application, Defects, and Business. After each answer you'll see a short explanation. Score, accuracy, and a per-category breakdown appear at the end.")
                    .font(.body).foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(GameData.quizCategories, id: \.self) { c in
                        MetricCard(label: c, value: "\(bank.filter { $0.kind == c }.count)", sub: "in the bank")
                    }
                }

                if best > 0 {
                    Callout("Your best so far: \(best) / 20.", title: "Personal best")
                }

                Button {
                    var picked: [GameData.MCQ] = []
                    for c in GameData.quizCategories {
                        picked += bank.filter { $0.kind == c }.shuffled().prefix(5)
                    }
                    session = MCQSession(questions: picked.shuffled())
                } label: {
                    Label("Start quiz", systemImage: "play.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(bank.isEmpty)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack { KnowledgeQuizView() }
}
