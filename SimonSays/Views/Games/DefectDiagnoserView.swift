import SwiftUI

/// Ten defects, four possible causes each. Spotting is half the job; knowing why is the other half.
struct DefectDiagnoserView: View {
    @State private var session: MCQSession? = nil
    @AppStorage("diagnoser.best") private var best = 0

    private static let typeNames: [String: String] = [
        "bubble": "Bubble", "lift": "Lifting edge", "orange-peel": "Orange peel", "stretch-mark": "Stretch mark",
        "contamination": "Contamination", "tear": "Tear", "yellowing": "Yellowing", "fingerprint": "Fingerprint",
        "pinhole": "Pinhole"
    ]
    static func label(_ kind: String) -> String { typeNames[kind] ?? kind.capitalized }

    var body: some View {
        Group {
            if let session {
                MCQSessionView(session: session, unitName: "defect", breakdownOrder: Array(Self.typeNames.keys).sorted(),
                               kindLabel: Self.label, bestKey: "diagnoser.best") { q in
                    VStack(alignment: .leading, spacing: 8) {
                        DefectIllustration(kind: q.kind)
                            .frame(height: 150)
                        Eyebrow("Most likely root cause?")
                    }
                } onExit: { self.session = nil }
            } else {
                intro
            }
        }
        .navigationTitle("Defect Diagnoser")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var intro: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Game · Diagnosis")
                Text("Ten defects, four causes each").font(.largeTitle.weight(.bold))
                Text("Each round shows you a defect on a panel with a short symptom description. Pick the most likely root cause from four options. After each answer, you'll see the explanation. Score, accuracy and best result appear at the end.")
                    .font(.body).foregroundStyle(.secondary)

                DefectIllustration(kind: "lift").frame(height: 150)

                if best > 0 {
                    Callout("Your best so far: \(best) / 10.", title: "Personal best")
                }

                Button {
                    session = MCQSession(questions: Array(GameData.diagnoser.shuffled().prefix(10)))
                } label: {
                    Label("Start round", systemImage: "play.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(GameData.diagnoser.isEmpty)
            }
            .padding()
        }
    }
}

/// A simple drawn panel with the defect type sketched on it.
struct DefectIllustration: View {
    let kind: String

    var body: some View {
        Canvas { ctx, size in
            let panel = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let corner: CGFloat = 14
            // Panel: dark blue paint with a soft highlight.
            ctx.fill(Path(roundedRect: panel, cornerRadius: corner), with: .color(Color(hex: 0x1F4E79)))
            var shine = Path()
            shine.move(to: CGPoint(x: 0, y: 0))
            shine.addLine(to: CGPoint(x: size.width * 0.55, y: 0))
            shine.addLine(to: CGPoint(x: size.width * 0.30, y: size.height))
            shine.addLine(to: CGPoint(x: 0, y: size.height))
            shine.closeSubpath()
            ctx.clip(to: Path(roundedRect: panel, cornerRadius: corner))
            ctx.fill(shine, with: .color(.white.opacity(0.06)))

            let c = CGPoint(x: size.width * 0.55, y: size.height * 0.5)
            let white = GraphicsContext.Shading.color(.white.opacity(0.85))
            let faint = GraphicsContext.Shading.color(.white.opacity(0.35))

            switch kind {
            case "bubble":
                for (dx, r) in [(0.0, 16.0), (-48.0, 9.0), (36.0, 11.0)] {
                    let p = CGPoint(x: c.x + dx, y: c.y + (dx == 0 ? 0 : 18))
                    ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)), with: .color(.white.opacity(0.22)))
                    ctx.stroke(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)), with: faint, lineWidth: 1.5)
                    ctx.fill(Path(ellipseIn: CGRect(x: p.x - r * 0.5, y: p.y - r * 0.5, width: r * 0.5, height: r * 0.5)), with: white)
                }
            case "lift":
                // Film edge peeling up at the panel's right corner.
                var p = Path()
                p.move(to: CGPoint(x: size.width - 90, y: size.height - 8))
                p.addQuadCurve(to: CGPoint(x: size.width - 8, y: size.height - 70), control: CGPoint(x: size.width - 20, y: size.height - 10))
                p.addLine(to: CGPoint(x: size.width - 8, y: size.height - 8))
                p.closeSubpath()
                ctx.fill(p, with: .color(.white.opacity(0.5)))
                ctx.stroke(p, with: white, lineWidth: 2)
            case "orange-peel":
                for row in 0..<4 {
                    var w = Path()
                    let y = size.height * 0.3 + CGFloat(row) * 20
                    w.move(to: CGPoint(x: size.width * 0.35, y: y))
                    var x = size.width * 0.35
                    while x < size.width * 0.8 {
                        w.addQuadCurve(to: CGPoint(x: x + 16, y: y), control: CGPoint(x: x + 8, y: y - 7))
                        w.addQuadCurve(to: CGPoint(x: x + 32, y: y), control: CGPoint(x: x + 24, y: y + 7))
                        x += 32
                    }
                    ctx.stroke(w, with: faint, lineWidth: 2)
                }
            case "stretch-mark":
                for i in 0..<6 {
                    var l = Path()
                    let x = size.width * 0.4 + CGFloat(i) * 14
                    l.move(to: CGPoint(x: x, y: size.height * 0.25))
                    l.addLine(to: CGPoint(x: x + 10, y: size.height * 0.75))
                    ctx.stroke(l, with: .color(.white.opacity(0.18 + Double(i) * 0.06)), lineWidth: 2)
                }
            case "contamination":
                for (dx, dy, r) in [(-40.0, -20.0, 3.5), (10.0, 25.0, 2.5), (35.0, -30.0, 4.0), (-10.0, 5.0, 2.0), (55.0, 15.0, 3.0)] {
                    let p = CGPoint(x: c.x + dx, y: c.y + dy)
                    ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)), with: .color(Color(hex: 0x0E1116)))
                    ctx.fill(Path(ellipseIn: CGRect(x: p.x - r * 2.4, y: p.y - r * 2.4, width: r * 4.8, height: r * 4.8)), with: .color(.white.opacity(0.12)))
                }
            case "tear":
                var t = Path()
                t.move(to: CGPoint(x: c.x - 60, y: c.y - 30))
                for (i, dy) in [12.0, -6.0, 14.0, -4.0, 16.0, 2.0].enumerated() {
                    t.addLine(to: CGPoint(x: c.x - 60 + CGFloat(i + 1) * 20, y: c.y - 30 + dy * 2.2))
                }
                ctx.stroke(t, with: white, lineWidth: 2.5)
            case "yellowing":
                let r = CGRect(x: size.width * 0.3, y: size.height * 0.2, width: size.width * 0.5, height: size.height * 0.6)
                ctx.fill(Path(roundedRect: r, cornerRadius: 30), with: .color(Color(hex: 0xDFA042).opacity(0.35)))
                ctx.fill(Path(roundedRect: r.insetBy(dx: 25, dy: 18), cornerRadius: 24), with: .color(Color(hex: 0xDFA042).opacity(0.3)))
            case "fingerprint":
                for i in 0..<5 {
                    let r = CGFloat(8 + i * 7)
                    var arc = Path()
                    arc.addArc(center: c, radius: r, startAngle: .degrees(200), endAngle: .degrees(340), clockwise: false)
                    ctx.stroke(arc, with: faint, lineWidth: 1.5)
                }
            default: // pinhole
                ctx.fill(Path(ellipseIn: CGRect(x: c.x - 2.5, y: c.y - 2.5, width: 5, height: 5)), with: .color(Color(hex: 0x0E1116)))
                ctx.stroke(Path(ellipseIn: CGRect(x: c.x - 14, y: c.y - 14, width: 28, height: 28)), with: faint, lineWidth: 1)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(alignment: .bottomLeading) {
            Text(DefectDiagnoserView.label(kind))
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.black.opacity(0.35), in: Capsule())
                .foregroundStyle(.white)
                .padding(8)
        }
    }
}

#Preview {
    NavigationStack { DefectDiagnoserView() }
}
