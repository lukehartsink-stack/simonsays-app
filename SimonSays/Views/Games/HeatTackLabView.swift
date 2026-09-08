import SwiftUI

/// Two-axis view of the workshop climate: bay temperature against relative humidity, with dew point.
struct HeatTackLabView: View {
    private static let tempMin = 5.0, tempMax = 45.0, tempColdToOk = 18.0, tempOkToHot = 30.0
    private static let rhMin = 0.0, rhMax = 100.0, rhDryToOk = 35.0, rhOkToHumid = 65.0

    private struct Zone {
        let severity: Severity
        let label: String
        let detail: String
    }
    private enum Severity { case green, amber, red
        var color: Color { switch self { case .green: return Theme.green; case .amber: return Theme.amber; case .red: return Theme.red } }
    }

    private static let zones: [String: Zone] = [
        "cold-dry": Zone(severity: .amber, label: "Cold and dry",
            detail: "Stiff film that will not take shape, slow tack, and static on everything you touch. Dust lands on the panel and on the film faster than you can clear it. Heat the bay, but heating alone drops the humidity further, so put moisture back in as you warm up."),
        "cold-ok": Zone(severity: .amber, label: "Too cold",
            detail: "The film will not shape and the adhesive will not tack fully. Water leaves slowly as well, so the bond takes longer to build. Bring the bay to at least 20°C before you start."),
        "cold-humid": Zone(severity: .red, label: "Cold and damp",
            detail: "The worst corner. Panels sit at or near dew point, so water condenses on the paint before the film is anywhere near it, and what does get trapped has almost no way out. Heat and dehumidify, and check the dew point reading against the panel."),
        "ok-dry": Zone(severity: .amber, label: "Too dry",
            detail: "The slip solution flashes off before you have the film placed, so the adhesive grabs early. Static pulls dust in at the same time. Re-wet as you work, and raise the humidity if the bay lets you."),
        "ok-ok": Zone(severity: .green, label: "Working zone",
            detail: "The film shapes, the adhesive tacks at a workable pace, and the water leaves in a sensible time. This is where you want to be."),
        "ok-humid": Zone(severity: .amber, label: "Too humid",
            detail: "It all installs, but the water takes far longer to get out. Haze and moisture pockets sit under the film for days and edges can lift before the bond has built. Dehumidify, and tell the customer the cure is longer than usual."),
        "hot-dry": Zone(severity: .red, label: "Hot and dry",
            detail: "The slip goes almost as fast as you spray it, so the film grabs before it is placed, and the top coat is soft enough to mark. Cool the bay and the panel, work smaller sections, and keep re-wetting."),
        "hot-ok": Zone(severity: .amber, label: "Too hot",
            detail: "The adhesive tacks faster than you can position, and warm film goes soft and over-stretches. Top coat distortion is possible. Cool the bay below 30°C."),
        "hot-humid": Zone(severity: .red, label: "Hot and humid",
            detail: "Panel heat makes the film grab straight away while the saturated air stops the trapped water leaving. Instant tack and a long hazy cure at the same time, and you are sweating onto the panel while you work. Cool and dehumidify before you start."),
    ]

    @State private var temp = 22.0
    @State private var rh = 50.0

    private var dewPoint: Double {
        // Magnus formula, Alduchov-Eskridge coefficients. RH floored at 1%.
        let b = 17.62, c = 243.12
        let g = log(max(1, rh) / 100) + (b * temp) / (c + temp)
        return (c * g) / (b - g)
    }
    private static func tempBand(_ t: Double) -> String { t < tempColdToOk ? "cold" : t > tempOkToHot ? "hot" : "ok" }
    private static func rhBand(_ r: Double) -> String { r < rhDryToOk ? "dry" : r > rhOkToHumid ? "humid" : "ok" }
    private var zone: Zone { Self.zones["\(Self.tempBand(temp))-\(Self.rhBand(rh))"] ?? Self.zones["ok-ok"]! }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Visualisation")
                Text("Heat & Tack Lab").font(.largeTitle.weight(.bold))
                Text("Drag the marker on the plot. The horizontal axis is the air temperature in your bay, the vertical axis is the relative humidity. Temperature decides how the film behaves and how quickly the adhesive tacks. Humidity decides how fast the water leaves. The green rectangle is the working window.")
                    .font(.body).foregroundStyle(.secondary)

                plot
                    .aspectRatio(1.15, contentMode: .fit)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))

                HStack(spacing: 10) {
                    MetricCard(label: "Air temperature", value: "\(Int(temp.rounded()))°C")
                    MetricCard(label: "Relative humidity", value: "\(Int(rh.rounded()))%")
                    MetricCard(label: "Dew point", value: String(format: "%.1f°C", dewPoint))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(zone.label).font(.headline).foregroundStyle(.white)
                    Text(zone.detail).font(.subheadline).foregroundStyle(.white.opacity(0.92))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(zone.severity.color, in: RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut(duration: 0.2), value: zone.label)

                Callout(String(format: "Any surface colder than %.1f°C will condense water out of this air. That is the number to hold against your panel, not against the room.", dewPoint), title: "Dew point")

                Button {
                    withAnimation(.spring(duration: 0.4)) { temp = 22; rh = 50 }
                } label: {
                    Label("Reset to sweet spot", systemImage: "arrow.counterclockwise").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Prose("What this shows", [
                    "The two things about your workshop you can measure with a fifteen-euro hygrometer, and what each one does to the job. Temperature governs the film and the adhesive: cold film will not shape and will not tack, hot film goes soft, over-stretches and marks. Humidity governs the water: dry air takes the slip solution away before you have the panel placed, and it charges film and paint with static so dust lands on both. Damp air does the opposite, holding the water under the film for days, so haze lingers and edges can lift before the bond has built. Both of these you fix with the room, not with your hands.",
                    "Dew point is the temperature at which the air in your bay gives its water back up. A car driven in on a cold morning is far colder than the air it is now sitting in, and if you start work before it has warmed through, you are laying film onto a panel that is quietly wetting itself. Let the car come up to bay temperature first, and check it with the infrared thermometer you already use for post-heating."
                ])
                .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Heat & Tack Lab")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Plot

    private let inset = EdgeInsets(top: 14, leading: 46, bottom: 40, trailing: 14)

    private func plotRect(_ size: CGSize) -> CGRect {
        CGRect(x: inset.leading, y: inset.top,
               width: size.width - inset.leading - inset.trailing,
               height: size.height - inset.top - inset.bottom)
    }
    private func x(_ t: Double, _ r: CGRect) -> CGFloat { r.minX + CGFloat((t - Self.tempMin) / (Self.tempMax - Self.tempMin)) * r.width }
    private func y(_ h: Double, _ r: CGRect) -> CGFloat { r.minY + CGFloat(1 - (h - Self.rhMin) / (Self.rhMax - Self.rhMin)) * r.height }

    private var plot: some View {
        GeometryReader { geo in
            let r = plotRect(geo.size)
            ZStack(alignment: .topLeading) {
                Canvas { ctx, size in
                    let tempEdges = [Self.tempMin, Self.tempColdToOk, Self.tempOkToHot, Self.tempMax]
                    let rhEdges = [Self.rhMin, Self.rhDryToOk, Self.rhOkToHumid, Self.rhMax]
                    let tb = ["cold", "ok", "hot"], rb = ["dry", "ok", "humid"]
                    for ti in 0..<3 {
                        for si in 0..<3 {
                            let z = Self.zones["\(tb[ti])-\(rb[si])"]!
                            let rect = CGRect(x: x(tempEdges[ti], r), y: y(rhEdges[si + 1], r),
                                              width: x(tempEdges[ti + 1], r) - x(tempEdges[ti], r),
                                              height: y(rhEdges[si], r) - y(rhEdges[si + 1], r))
                            ctx.fill(Path(rect), with: .color(z.severity.color.opacity(z.severity == .green ? 0.28 : 0.16)))
                        }
                    }
                    // Sweet spot outline + label.
                    let sweet = CGRect(x: x(Self.tempColdToOk, r) + 2, y: y(Self.rhOkToHumid, r) + 2,
                                       width: x(Self.tempOkToHot, r) - x(Self.tempColdToOk, r) - 4,
                                       height: y(Self.rhDryToOk, r) - y(Self.rhOkToHumid, r) - 4)
                    ctx.stroke(Path(roundedRect: sweet, cornerRadius: 4), with: .color(Theme.green), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                    ctx.draw(Text("Sweet spot").font(.caption.weight(.semibold)).foregroundColor(Theme.green),
                             at: CGPoint(x: sweet.midX, y: sweet.midY - 7))
                    ctx.draw(Text("~22–25°C · 40–60% RH").font(.system(size: 9)).foregroundColor(Theme.green),
                             at: CGPoint(x: sweet.midX, y: sweet.midY + 8))

                    // Axes and ticks.
                    var axes = Path()
                    axes.move(to: CGPoint(x: r.minX, y: r.maxY)); axes.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
                    axes.move(to: CGPoint(x: r.minX, y: r.minY)); axes.addLine(to: CGPoint(x: r.minX, y: r.maxY))
                    ctx.stroke(axes, with: .color(Theme.muted), lineWidth: 1)
                    for t in tempEdges {
                        ctx.draw(Text("\(Int(t))°C").font(.caption2).foregroundColor(Theme.muted), at: CGPoint(x: x(t, r), y: r.maxY + 10))
                    }
                    for h in rhEdges {
                        ctx.draw(Text("\(Int(h))%").font(.caption2).foregroundColor(Theme.muted), at: CGPoint(x: r.minX - 18, y: y(h, r)))
                    }
                    ctx.draw(Text("Bay air temperature").font(.caption).foregroundColor(Theme.body), at: CGPoint(x: r.midX, y: r.maxY + 27))
                    var vctx = ctx
                    vctx.translateBy(x: 12, y: r.midY)
                    vctx.rotate(by: .degrees(-90))
                    vctx.draw(Text("Relative humidity").font(.caption).foregroundColor(Theme.body), at: .zero)

                    // Crosshair.
                    let mx = x(temp, r), my = y(rh, r)
                    var cross = Path()
                    cross.move(to: CGPoint(x: r.minX, y: my)); cross.addLine(to: CGPoint(x: r.maxX, y: my))
                    cross.move(to: CGPoint(x: mx, y: r.minY)); cross.addLine(to: CGPoint(x: mx, y: r.maxY))
                    ctx.stroke(cross, with: .color(Theme.accentDeep.opacity(0.5)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                }

                Circle()
                    .fill(Theme.accent)
                    .overlay(Circle().stroke(.white, lineWidth: 2.5))
                    .frame(width: 24, height: 24)
                    .shadow(radius: 2, y: 1)
                    .position(x: x(temp, r), y: y(rh, r))
                    .allowsHitTesting(false)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { v in
                        let px = min(max(v.location.x, r.minX), r.maxX)
                        let py = min(max(v.location.y, r.minY), r.maxY)
                        temp = Self.tempMin + Double((px - r.minX) / r.width) * (Self.tempMax - Self.tempMin)
                        rh = Self.rhMax - Double((py - r.minY) / r.height) * (Self.rhMax - Self.rhMin)
                    }
            )
        }
    }
}

#Preview {
    NavigationStack { HeatTackLabView() }
}
