import SwiftUI

/// Two panels: plain paint and paint with PPF. Scratch both, then run the heat lamp over the PPF panel.
struct SelfHealDemoView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case scratch = "Scratch", heat = "Heat"
        var id: String { rawValue }
    }

    @State private var mode: Mode = .scratch
    @State private var plain = HealPanel(canHeal: false)
    @State private var ppf = HealPanel(canHeal: true)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Visualisation · Customer-facing")
                Text("Self-heal Demo").font(.largeTitle.weight(.bold))
                Text("Two panels: plain paint on top, paint with PPF below. In Scratch mode, drag across either panel to mark it. Then switch to Heat mode and drag the lamp over the PPF panel — wherever the lamp passes, that part of the scratch fades. Linger longer and it disappears completely. The plain panel keeps its scratches forever.")
                    .font(.body).foregroundStyle(.secondary)

                Picker("Mode", selection: $mode) {
                    ForEach(Mode.allCases) { m in
                        Label(m.rawValue, systemImage: m == .scratch ? "pencil.line" : "sun.max.fill").tag(m)
                    }
                }
                .pickerStyle(.segmented)

                Text(mode == .scratch ? "Drag across a panel to scratch it." : "Drag the lamp over the PPF panel — scratches fade where it passes.")
                    .font(.caption).foregroundStyle(.secondary)

                panelBlock(title: "Plain paint", subtitle: "No protection", stat: "Permanent scratches: \(plain.strokes.count)", panel: plain)
                panelBlock(title: "With PPF", subtitle: "Self-healing top coat", stat: "Visible: \(ppf.strokes.count) · Healed: \(ppf.healed)", panel: ppf)

                Button {
                    plain.reset(); ppf.reset()
                } label: {
                    Label("Reset both panels", systemImage: "arrow.counterclockwise").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Prose("What this shows", [
                    "PPF films have a self-healing top coat. The polymer chains in the top coat can be pushed out of place by a light scratch but stay connected. Apply heat — a warm bay, a heat gun, even a summer sun — and the chains re-set. The scratch disappears.",
                    "What this won't fix: deep cuts that go through the top coat into the film body, or anything that reaches the paint underneath. For those, the film still does the more important job — it took the damage, the paint didn't."
                ])
                .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Self-heal Demo")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func panelBlock(title: String, subtitle: String, stat: String, panel: HealPanel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
                Spacer()
            }
            HealPanelView(panel: panel, mode: mode)
                .aspectRatio(1.7, contentMode: .fit)
            Text(stat).font(.caption.weight(.semibold)).foregroundStyle(Theme.accent)
        }
    }
}

@Observable
final class HealPanel {
    struct Segment {
        var a: CGPoint
        var b: CGPoint
        var opacity: Double
    }
    struct Stroke: Identifiable {
        let id = UUID()
        var segments: [Segment] = []
        var last: CGPoint
    }

    let canHeal: Bool
    var strokes: [Stroke] = []
    var healed = 0
    var lamp: CGPoint? = nil

    init(canHeal: Bool) { self.canHeal = canHeal }

    // Points are in unit space (0…1 of the panel's width and height).
    private let minStep: CGFloat = 0.006
    private let healPerTick = 0.05
    private let heatRadius: CGFloat = 0.11

    func begin(at p: CGPoint) {
        strokes.append(Stroke(last: p))
    }

    func extend(to p: CGPoint) {
        guard var s = strokes.last else { return }
        if hypot(p.x - s.last.x, p.y - s.last.y) < minStep { return }
        s.segments.append(Segment(a: s.last, b: p, opacity: 1))
        s.last = p
        strokes[strokes.count - 1] = s
    }

    func heat(at p: CGPoint) {
        lamp = p
        guard canHeal else { return }
        let r2 = heatRadius * heatRadius
        for i in stride(from: strokes.count - 1, through: 0, by: -1) {
            var s = strokes[i]
            for j in stride(from: s.segments.count - 1, through: 0, by: -1) {
                let m = CGPoint(x: (s.segments[j].a.x + s.segments[j].b.x) / 2, y: (s.segments[j].a.y + s.segments[j].b.y) / 2)
                let dx = m.x - p.x, dy = m.y - p.y
                if dx * dx + dy * dy <= r2 {
                    s.segments[j].opacity -= healPerTick
                    if s.segments[j].opacity <= 0 { s.segments.remove(at: j) }
                }
            }
            if s.segments.isEmpty {
                strokes.remove(at: i)
                healed += 1
            } else {
                strokes[i] = s
            }
        }
    }

    func endHeat() { lamp = nil }

    func reset() {
        strokes = []
        healed = 0
        lamp = nil
    }
}

struct HealPanelView: View {
    let panel: HealPanel
    let mode: SelfHealDemoView.Mode

    var body: some View {
        // Read the model here (tracked by SwiftUI) rather than only inside the Canvas closure.
        let strokes = panel.strokes
        let lamp = panel.lamp
        return GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
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

                for s in strokes {
                    for seg in s.segments {
                        var p = Path()
                        p.move(to: CGPoint(x: seg.a.x * size.width, y: seg.a.y * size.height))
                        p.addLine(to: CGPoint(x: seg.b.x * size.width, y: seg.b.y * size.height))
                        ctx.stroke(p, with: .color(.white.opacity(0.85 * seg.opacity)), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    }
                }

                if let lamp {
                    let r = size.width * 0.11
                    let c = CGPoint(x: lamp.x * size.width, y: lamp.y * size.height)
                    ctx.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2)),
                             with: .radialGradient(Gradient(colors: [Color(hex: 0xDFA042).opacity(0.55), Color(hex: 0xDFA042).opacity(0)]),
                                                   center: c, startRadius: 0, endRadius: r))
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { v in
                        let p = CGPoint(x: min(max(v.location.x / w, 0), 1), y: min(max(v.location.y / h, 0), 1))
                        switch mode {
                        case .scratch:
                            if v.translation == .zero { panel.begin(at: p) } else { panel.extend(to: p) }
                        case .heat:
                            panel.heat(at: p)
                        }
                    }
                    .onEnded { _ in panel.endHeat() }
            )
        }
    }
}

#Preview {
    NavigationStack { SelfHealDemoView() }
}
