import SwiftUI

/// Drag the panels into the order you'd install them on a full-body PPF job.
struct PanelSequencePuzzleView: View {
    private let canonical = GameData.panels

    @State private var order: [String] = []
    @State private var locked = false
    @State private var startedAt: Date? = nil
    @State private var elapsed: TimeInterval = 0
    @State private var result: (correct: Int, total: Int)? = nil
    @AppStorage("panelseq.bestCorrect") private var bestCorrect = 0
    @AppStorage("panelseq.bestTotal") private var bestTotal = 0
    @AppStorage("panelseq.bestTime") private var bestTime: Double = 0

    private let ticker = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Game · Planning")
                    Text("The panels below are scrambled. Drag them up or down to put them in the order you'd install them on a full-body PPF job. The timer starts when you make your first move.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }

            Section {
                HStack(spacing: 10) {
                    MetricCard(label: "Time", value: format(elapsed))
                    MetricCard(label: "Correct", value: result.map { "\($0.correct) / \($0.total)" } ?? "— / —")
                    MetricCard(label: "Best", value: bestTotal > 0 ? "\(bestCorrect) / \(bestTotal)" : "—",
                               sub: bestTotal > 0 ? format(bestTime) : nil)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .listRowBackground(Color.clear)
            }

            Section {
                ForEach(Array(order.enumerated()), id: \.element) { i, name in
                    HStack(spacing: 12) {
                        Text("\(i + 1)")
                            .font(.subheadline.weight(.bold))
                            .frame(width: 28, height: 28)
                            .background(badgeColor(index: i, name: name), in: RoundedRectangle(cornerRadius: 7))
                            .foregroundStyle(.white)
                        Text(name)
                        Spacer()
                        if locked, let target = canonical.firstIndex(of: name), target != i {
                            Text("→ \(target + 1)").font(.caption.weight(.semibold)).foregroundStyle(Theme.red)
                        }
                    }
                }
                .onMove { from, to in
                    guard !locked else { return }
                    if startedAt == nil { startedAt = Date() }
                    order.move(fromOffsets: from, toOffset: to)
                }
                .moveDisabled(locked)
            } header: {
                Text(locked ? "Result" : "Drag a row up or down to reorder")
            } footer: {
                if let result {
                    Text(verdict(result) + " \(result.correct) of \(result.total) panels in the correct slot · \(format(elapsed)).")
                }
            }

            Section {
                if locked {
                    Button { reshuffle() } label: {
                        Label("Play again", systemImage: "shuffle").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button { check() } label: {
                        Label("Check answer", systemImage: "checkmark").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Reshuffle") { reshuffle() }
                        .frame(maxWidth: .infinity)
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())

            Section {
                Text("Why sequencing matters: adjacent panels share edges, and the panel installed first determines which way the neighbour's tuck has to go. Get the order wrong and you'll fight every tuck; get it right and the film almost places itself. Tack times, dust exposure, and curing windows also stack up — a sensible sequence is half the install.")
                Text("For symmetrical panels (wings, mirrors, doors), start on the passenger side. You get one practice run before the side the driver looks at every day. The driver pays the bill; the driver side gets your best work.")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .environment(\.editMode, .constant(locked ? .inactive : .active))
        .navigationTitle("Panel Sequence Puzzle")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if order.isEmpty { reshuffle() } }
        .onReceive(ticker) { now in
            if let startedAt, !locked { elapsed = now.timeIntervalSince(startedAt) }
        }
    }

    private func badgeColor(index: Int, name: String) -> Color {
        guard locked else { return Theme.iconBlue }
        return canonical.firstIndex(of: name) == index ? Theme.green : Theme.red
    }

    private func reshuffle() {
        var shuffled = canonical.shuffled()
        // Avoid handing out an already-correct order.
        var tries = 0
        while shuffled == canonical && tries < 10 { shuffled = canonical.shuffled(); tries += 1 }
        order = shuffled
        locked = false
        startedAt = nil
        elapsed = 0
        result = nil
    }

    private func check() {
        if let startedAt { elapsed = Date().timeIntervalSince(startedAt) }
        let correct = zip(order, canonical).filter { $0 == $1 }.count
        let total = canonical.count
        result = (correct, total)
        locked = true
        // Best: most correct, tiebreak fastest time.
        if bestTotal == 0 || correct > bestCorrect || (correct == bestCorrect && elapsed < bestTime) {
            bestCorrect = correct
            bestTotal = total
            bestTime = elapsed
        }
    }

    private func verdict(_ r: (correct: Int, total: Int)) -> String {
        if r.correct == r.total { return "Perfect sequence." }
        if r.correct >= Int((Double(r.total) * 0.8).rounded(.up)) { return "Close." }
        if r.correct >= Int((Double(r.total) * 0.5).rounded(.up)) { return "Halfway there." }
        return "Keep practising."
    }

    private func format(_ t: TimeInterval) -> String {
        let s = Int(t)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}

#Preview {
    NavigationStack { PanelSequencePuzzleView() }
}
