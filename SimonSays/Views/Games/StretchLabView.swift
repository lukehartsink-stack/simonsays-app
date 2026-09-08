import SwiftUI

/// Drag the four corners of a film panel and watch the grid distort the way film does.
struct StretchLabView: View {
    // Corners in unit space (0…1): top-left, top-right, bottom-right, bottom-left.
    private static let initial = [CGPoint(x: 0.2, y: 0.2), CGPoint(x: 0.8, y: 0.2), CGPoint(x: 0.8, y: 0.8), CGPoint(x: 0.2, y: 0.8)]
    private static let originalEdge: CGFloat = 0.6
    private static let originalArea: CGFloat = 0.36
    private static let pad: CGFloat = 0.03
    private static let gridN = 10

    private struct Zone {
        let max: Double
        let label: String
        let sub: String
        let color: Color
    }
    private static let zones = [
        Zone(max: 0.15, label: "Working zone", sub: "safe install territory", color: Theme.green),
        Zone(max: 0.30, label: "Caution", sub: "thinning begins to show", color: Theme.amber),
        Zone(max: 0.50, label: "Heavy stretch", sub: "optical and adhesive loss", color: Theme.rust),
        Zone(max: .infinity, label: "Failure zone", sub: "tearing or full distortion likely", color: Theme.red),
    ]

    @State private var corners = StretchLabView.initial

    private var area: CGFloat {
        let p = corners
        var s: CGFloat = 0
        for i in 0..<4 {
            let a = p[i], b = p[(i + 1) % 4]
            s += a.x * b.y - b.x * a.y
        }
        return abs(s) / 2
    }
    private var areaStretch: Double { max(0, Double(area / Self.originalArea - 1)) }
    private var maxEdgeStretch: Double {
        var worst: CGFloat = 0
        for i in 0..<4 {
            let a = corners[i], b = corners[(i + 1) % 4]
            worst = max(worst, (hypot(a.x - b.x, a.y - b.y) - Self.originalEdge) / Self.originalEdge)
        }
        return max(0, Double(worst))
    }
    private var thickness: Double { min(1, Double(Self.originalArea / max(area, 0.0001))) }
    private var zone: Zone { Self.zones.first { areaStretch <= $0.max } ?? Self.zones[3] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Visualisation")
                Text("Stretch Lab").font(.largeTitle.weight(.bold))
                Text("Drag the four blue handles to stretch the film panel. The grid distorts the way the film does — heavier in the corners that are pulled hardest. Watch the readouts: area stretch, the worst single edge, and the resulting film thickness assuming the volume of film is conserved.")
                    .font(.body).foregroundStyle(.secondary)

                canvas
                    .aspectRatio(1, contentMode: .fit)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))

                HStack(spacing: 10) {
                    MetricCard(label: "Area stretch", value: pct(areaStretch), sub: "total surface increase")
                    MetricCard(label: "Max edge stretch", value: pct(maxEdgeStretch), sub: "worst single edge")
                    MetricCard(label: "Film thickness", value: "\(Int((thickness * 100).rounded()))%", sub: "of original")
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(zone.label).font(.headline).foregroundStyle(.white)
                    Text(zone.sub).font(.caption).foregroundStyle(.white.opacity(0.85))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(zone.color, in: RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: zone.label)

                Button {
                    withAnimation(.spring(duration: 0.4)) { corners = Self.initial }
                } label: {
                    Label("Reset to flat", systemImage: "arrow.counterclockwise").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Text("What this shows: PPF films have a working stretch range. Inside it, the film keeps its thickness, its adhesive bond, and its top coat clarity. Push beyond it and the film thins, the top coat distorts (orange peel, optical haze), the adhesive layer goes thinner than designed, and stored tension makes lifting more likely over time.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Stretch Lab")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            ZStack(alignment: .topLeading) {
                Canvas { ctx, _ in
                    func px(_ p: CGPoint) -> CGPoint { CGPoint(x: p.x * s, y: p.y * s) }

                    // Original outline, faded.
                    var orig = Path()
                    orig.addLines(Self.initial.map(px))
                    orig.closeSubpath()
                    ctx.stroke(orig, with: .color(Theme.muted.opacity(0.5)), style: StrokeStyle(lineWidth: 1, dash: [5, 4]))

                    // Film.
                    var film = Path()
                    film.addLines(corners.map(px))
                    film.closeSubpath()
                    ctx.fill(film, with: .color(zone.color.opacity(0.18)))
                    ctx.stroke(film, with: .color(zone.color), lineWidth: 2)

                    // Grid via bilinear interpolation.
                    for i in 0...Self.gridN {
                        let t = CGFloat(i) / CGFloat(Self.gridN)
                        let major = i == 0 || i == Self.gridN || i == Self.gridN / 2
                        var h = Path(), v = Path()
                        for j in 0...Self.gridN {
                            let u = CGFloat(j) / CGFloat(Self.gridN)
                            let hp = px(bilinear(u, t)), vp = px(bilinear(t, u))
                            if j == 0 { h.move(to: hp); v.move(to: vp) } else { h.addLine(to: hp); v.addLine(to: vp) }
                        }
                        let shade = GraphicsContext.Shading.color(Theme.accentDeep.opacity(major ? 0.55 : 0.28))
                        ctx.stroke(h, with: shade, lineWidth: major ? 1.2 : 0.7)
                        ctx.stroke(v, with: shade, lineWidth: major ? 1.2 : 0.7)
                    }
                }
                .frame(width: s, height: s)

                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(Theme.accent)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                        .frame(width: 26, height: 26)
                        .shadow(radius: 2, y: 1)
                        .position(x: corners[i].x * s, y: corners[i].y * s)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    corners[i] = CGPoint(
                                        x: min(max(v.location.x / s, Self.pad), 1 - Self.pad),
                                        y: min(max(v.location.y / s, Self.pad), 1 - Self.pad)
                                    )
                                }
                        )
                }
            }
            .frame(width: s, height: s)
            .frame(maxWidth: .infinity)
        }
    }

    private func bilinear(_ u: CGFloat, _ v: CGFloat) -> CGPoint {
        let tl = corners[0], tr = corners[1], br = corners[2], bl = corners[3]
        return CGPoint(
            x: (1 - u) * (1 - v) * tl.x + u * (1 - v) * tr.x + u * v * br.x + (1 - u) * v * bl.x,
            y: (1 - u) * (1 - v) * tl.y + u * (1 - v) * tr.y + u * v * br.y + (1 - u) * v * bl.y
        )
    }

    private func pct(_ v: Double) -> String {
        let p = Int((v * 100).rounded())
        return (p > 0 ? "+" : "") + "\(p)%"
    }
}

#Preview {
    NavigationStack { StretchLabView() }
}
