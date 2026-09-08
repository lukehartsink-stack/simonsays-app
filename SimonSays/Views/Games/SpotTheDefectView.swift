import SwiftUI

/// Sixty-second eye-training drill: tap bubbles, lifts and dirt specks before their ring runs out.
struct SpotTheDefectView: View {
    @State private var game = SpotGame()
    @AppStorage("spot.best") private var best = 0
    private let ticker = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Game · Eye drill")
                Text("Spot the Defect").font(.largeTitle.weight(.bold))
                Text("Defects appear on the panel — bubbles, lifting edges, and dirt specks. Tap each one before its ring runs out and it locks in as a miss. The game speeds up as it goes.")
                    .font(.body).foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    MetricCard(label: "Time", value: String(format: "%.1f", game.timeLeft))
                    MetricCard(label: "Score", value: "\(game.score)")
                    MetricCard(label: "Hits", value: "\(game.hits)")
                    MetricCard(label: "Misses", value: "\(game.misses)")
                }

                panel
                    .aspectRatio(5.0 / 3.0, contentMode: .fit)

                Text(game.hint).font(.caption).foregroundStyle(.secondary)

                HStack {
                    Button {
                        game.start()
                    } label: {
                        Label(game.phase == .over ? "Play again" : "Start game", systemImage: "play.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(game.phase == .running)
                    Button("Reset") { game.reset() }
                        .buttonStyle(.bordered)
                }

                if game.phase == .over {
                    results
                }

                Text("What this trains: the eye for the small things — a bubble at the edge of a bonnet, a lift on a bumper corner, a dirt speck under a clear panel. The same scan you'd do in QC before the customer handover, compressed into a minute. Run it as a warm-up before a class, or after a long install when fatigue starts to dull what you're seeing.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Spot the Defect")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(ticker) { now in
            game.tick(now)
            if game.phase == .over, game.score > best { best = game.score }
        }
    }

    private var panel: some View {
        GeometryReader { geo in
            let scale = geo.size.width / 600   // the site's panel is 600 × 360 units
            ZStack {
                Canvas { ctx, size in
                    let rect = CGRect(origin: .zero, size: size)
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 14), with: .color(Color(hex: 0x1F4E79)))
                    ctx.clip(to: Path(roundedRect: rect, cornerRadius: 14))
                    var shine = Path()
                    shine.move(to: .zero)
                    shine.addLine(to: CGPoint(x: size.width * 0.55, y: 0))
                    shine.addLine(to: CGPoint(x: size.width * 0.30, y: size.height))
                    shine.addLine(to: CGPoint(x: 0, y: size.height))
                    shine.closeSubpath()
                    ctx.fill(shine, with: .color(.white.opacity(0.06)))
                }
                ForEach(game.defects) { d in
                    DefectMarker(defect: d, scale: scale, remaining: game.remaining(for: d))
                        .position(x: d.x * scale, y: d.y * scale)
                        .onTapGesture { game.hit(d) }
                }
                ForEach(game.floaters) { f in
                    Text(f.text)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(f.good ? Theme.green : Theme.red)
                        .position(x: f.x * scale, y: f.y * scale - 26 * scale)
                        .transition(.opacity)
                }
            }
        }
    }

    private var results: some View {
        let total = game.hits + game.misses
        let acc = total > 0 ? Int((Double(game.hits) / Double(total) * 100).rounded()) : 0
        return VStack(alignment: .leading, spacing: 10) {
            Text("Game over").font(.headline)
            HStack(spacing: 10) {
                MetricCard(label: "Score", value: "\(game.score)")
                MetricCard(label: "Accuracy", value: "\(acc)%")
                MetricCard(label: "Best", value: "\(max(best, game.score))")
            }
            Text(verdict(acc: acc)).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Theme.tint, in: RoundedRectangle(cornerRadius: 12))
    }

    private func verdict(acc: Int) -> String {
        if game.score > game.previousBest && game.previousBest > 0 { return "New personal best — beat your previous score of \(game.previousBest)." }
        if game.previousBest == 0 { return "First run logged as your personal best." }
        if acc >= 90 { return "Sharp eye. Very few got past you." }
        if acc >= 70 { return "Solid — most of them caught, a handful slipped through." }
        if acc >= 50 { return "Half caught, half missed. Work on the smaller defects." }
        return "Tough run. The dirt specks are the hardest — they're worth the most points."
    }
}

@Observable
final class SpotGame {
    enum Phase { case idle, running, over }
    enum Kind: CaseIterable {
        case bubble, lift, dirt
        var weight: Int { switch self { case .bubble: return 5; case .lift: return 3; case .dirt: return 2 } }
        var points: Int { switch self { case .bubble: return 10; case .lift: return 15; case .dirt: return 25 } }
        var hitRadius: CGFloat { self == .dirt ? 14 : 22 }
    }
    struct Defect: Identifiable {
        let id: Int
        let kind: Kind
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let born: Date
    }
    struct Floater: Identifiable {
        let id = UUID()
        let text: String
        let good: Bool
        let x: CGFloat
        let y: CGFloat
        let until: Date
    }

    static let seconds = 60.0
    static let lifetime = 2.5
    static let spawnStart = 1.4, spawnEnd = 0.6
    static let missPenalty = 5
    static let maxOnScreen = 6
    static let panelW: CGFloat = 600, panelH: CGFloat = 360, margin: CGFloat = 30

    var phase: Phase = .idle
    var score = 0
    var hits = 0
    var misses = 0
    var timeLeft = SpotGame.seconds
    var defects: [Defect] = []
    var floaters: [Floater] = []
    var hint = "Press Start to begin. 60 seconds."
    var previousBest = 0

    private var startedAt = Date()
    private var nextSpawn = Date()
    private var counter = 0

    func start() {
        previousBest = UserDefaults.standard.integer(forKey: "spot.best")
        phase = .running
        score = 0; hits = 0; misses = 0
        timeLeft = Self.seconds
        defects = []; floaters = []
        startedAt = Date()
        nextSpawn = startedAt.addingTimeInterval(0.6)
        hint = "Tap defects before the ring runs out."
    }

    func reset() {
        phase = .idle
        score = 0; hits = 0; misses = 0
        timeLeft = Self.seconds
        defects = []; floaters = []
        hint = "Press Start to begin. 60 seconds."
    }

    func remaining(for d: Defect) -> Double {
        max(0, 1 - Date().timeIntervalSince(d.born) / Self.lifetime)
    }

    func tick(_ now: Date) {
        floaters.removeAll { $0.until < now }
        guard phase == .running else { return }
        timeLeft = max(0, Self.seconds - now.timeIntervalSince(startedAt))
        if timeLeft <= 0 {
            phase = .over
            defects = []
            hint = "Time's up."
            return
        }
        // Expire defects that ran out.
        let expired = defects.filter { now.timeIntervalSince($0.born) >= Self.lifetime }
        for d in expired { miss(d, now: now) }
        // Spawn on the accelerating schedule.
        if now >= nextSpawn {
            spawn(now: now)
            let progress = 1 - timeLeft / Self.seconds
            nextSpawn = now.addingTimeInterval(Self.spawnStart + (Self.spawnEnd - Self.spawnStart) * progress)
        }
    }

    private func spawn(now: Date) {
        guard defects.count < Self.maxOnScreen else { return }
        let total = Kind.allCases.reduce(0) { $0 + $1.weight }
        var r = Int.random(in: 0..<total)
        var kind = Kind.bubble
        for k in Kind.allCases { r -= k.weight; if r < 0 { kind = k; break } }
        counter += 1
        let size: CGFloat
        switch kind {
        case .bubble: size = .random(in: 11...17)
        case .lift: size = .random(in: 18...28)
        case .dirt: size = .random(in: 3.5...6)
        }
        defects.append(Defect(id: counter, kind: kind,
                              x: .random(in: Self.margin...(Self.panelW - Self.margin)),
                              y: .random(in: Self.margin...(Self.panelH - Self.margin)),
                              size: size, born: now))
    }

    func hit(_ d: Defect) {
        guard phase == .running, defects.contains(where: { $0.id == d.id }) else { return }
        defects.removeAll { $0.id == d.id }
        hits += 1
        score += d.kind.points
        floaters.append(Floater(text: "+\(d.kind.points)", good: true, x: d.x, y: d.y, until: Date().addingTimeInterval(0.7)))
    }

    private func miss(_ d: Defect, now: Date) {
        defects.removeAll { $0.id == d.id }
        misses += 1
        score = max(0, score - Self.missPenalty)
        floaters.append(Floater(text: "−\(Self.missPenalty)", good: false, x: d.x, y: d.y, until: now.addingTimeInterval(0.7)))
    }
}

/// One defect with its countdown ring. Sized in the site's 600-unit panel space, scaled to the view.
struct DefectMarker: View {
    let defect: SpotGame.Defect
    let scale: CGFloat
    let remaining: Double

    var body: some View {
        let ringR = (defect.kind.hitRadius + 4) * scale
        ZStack {
            Circle()
                .trim(from: 0, to: remaining)
                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                .rotationEffect(.degrees(-90))
                .frame(width: ringR * 2, height: ringR * 2)
            shape
        }
        .frame(width: ringR * 2 + 8, height: ringR * 2 + 8)
        .contentShape(Circle())
    }

    @ViewBuilder private var shape: some View {
        let s = defect.size * scale
        switch defect.kind {
        case .bubble:
            ZStack {
                Circle().fill(.white.opacity(0.25)).overlay(Circle().stroke(.white.opacity(0.6), lineWidth: 1.5))
                    .frame(width: s * 2, height: s * 2)
                Circle().fill(.white.opacity(0.85)).frame(width: s * 0.56, height: s * 0.56).offset(x: -s * 0.35, y: -s * 0.35)
            }
        case .lift:
            LiftShape().stroke(Color.white.opacity(0.9), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round))
                .frame(width: s * 2, height: s * 0.9)
        case .dirt:
            Circle().fill(Color(hex: 0x0E1116)).frame(width: s * 2, height: s * 2)
                .overlay(Circle().stroke(.white.opacity(0.25), lineWidth: 1))
        }
    }
}

/// Peeled-edge crescent.
struct LiftShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY - rect.height))
        return p
    }
}

#Preview {
    NavigationStack { SpotTheDefectView() }
}
