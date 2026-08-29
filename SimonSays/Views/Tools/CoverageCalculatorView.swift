import SwiftUI

struct CoverageCalculatorView: View {
    @State private var rollWidth: Double = 1.52
    @State private var trimCm: Double = 2
    @State private var marginPct: Double = 10
    @State private var costPerM2: Double = 56
    @State private var currency: Currency = .eur
    @State private var surfaces: [CoverageEngine.Surface] = [
        .init(id: 1, name: "Example surface", length: 1.0, width: 1.0, qty: 1)
    ]
    @State private var nextID = 2
    @State private var layoutTab = 0

    private var result: CoverageEngine.Result {
        CoverageEngine.compute(surfaces: surfaces, rollWidth: rollWidth, trimCm: trimCm, marginPct: marginPct, costPerM2: costPerM2)
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Training Tools · Free tool")
                    Text("Working out how much film a job actually consumes — including the trim on every edge and the safety margin on the total — and showing the saving when smaller pieces nest into the offcuts of bigger ones. Use the totals as a guide, not a contract. Always verify before you order.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }

            Section {
                NumberField(label: "Roll width", value: $rollWidth, decimals: 2, suffix: "m")
                NumberField(label: "Trim per side", value: $trimCm, decimals: 1, suffix: "cm")
                NumberField(label: "Safety margin", value: $marginPct, decimals: 0, suffix: "%")
                NumberField(label: "Cost per m²", value: $costPerM2, decimals: 2, suffix: currency.symbol.trimmingCharacters(in: .whitespaces))
                Picker("Currency", selection: $currency) {
                    ForEach(Currency.allCases) { c in Text(c.label).tag(c) }
                }
            } header: {
                Text("Settings")
            } footer: {
                Text("Trim per side is a fixed allowance added to every edge of every piece for handling, alignment, and edge trimming — two centimetres is a sensible default. The safety margin is a percentage added to the total film at the end: five to ten per cent for clean flat work, fifteen or more for heavily curved surfaces.")
            }

            Section {
                ForEach($surfaces) { $s in
                    surfaceEditor($s)
                }
                .onDelete { idx in surfaces.remove(atOffsets: idx) }
                Button {
                    guard surfaces.count < CoverageEngine.maxSurfaces else { return }
                    surfaces.append(.init(id: nextID, name: "New surface", length: 1.0, width: 1.0, qty: 1))
                    nextID += 1
                } label: {
                    Label("Add surface", systemImage: "plus.circle.fill")
                }
                .disabled(surfaces.count >= CoverageEngine.maxSurfaces)
            } header: {
                Text("Surfaces")
            } footer: {
                Text(surfaces.count >= CoverageEngine.maxSurfaces
                     ? "Maximum of \(CoverageEngine.maxSurfaces) surfaces reached. Remove one to add another."
                     : "\(surfaces.count) of \(CoverageEngine.maxSurfaces) surfaces used. Length runs along the longest edge of the piece; width is across it. Quantity covers identical pieces. Swipe left to remove a surface.")
            }

            summarySection
            layoutSection
            breakdownSection

            Section {
                DisclaimerFooter(text: "This tool is intended as a guide only. All calculations should be independently verified before ordering materials or providing quotes. simonsays.coach accepts no liability for errors, omissions, or losses arising from reliance on the figures produced by this calculator. Material requirements vary depending on surface complexity, installer technique, vehicle or fixture geometry, and waste during application. Always allow additional material for complex shapes, wrap-around edges, and corrections.")
            }
        }
        .navigationTitle("Coverage Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }

    private func surfaceEditor(_ s: Binding<CoverageEngine.Surface>) -> some View {
        let index = surfaces.firstIndex(where: { $0.id == s.wrappedValue.id }) ?? 0
        let color = Theme.chart[index % Theme.chart.count]
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle().fill(color).frame(width: 10, height: 10)
                TextField("Surface name", text: s.name)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(color)
            }
            HStack(spacing: 12) {
                dimField("Length (m)", s.length)
                dimField("Width (m)", s.width)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Qty").font(.caption2).foregroundStyle(.secondary)
                    Stepper(value: s.qty, in: 1...50) {
                        Text("\(s.wrappedValue.qty)").font(.body.monospacedDigit())
                    }
                    .labelsHidden()
                }
            }
            Text("Net area: \(Format.fixed(s.wrappedValue.netArea)) m²")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func dimField(_ label: String, _ value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption2).foregroundStyle(.secondary)
            TextField("0", value: value, format: .number.precision(.fractionLength(0...2)))
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 80)
        }
    }

    private var summarySection: some View {
        let r = result
        let cu = currency.symbol
        return Section("Summary") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MetricCard(label: "Net area", value: "\(Format.fixed(r.netArea)) m²", sub: "actual surface")
                MetricCard(label: "Cut area", value: "\(Format.fixed(r.cutArea)) m²", sub: "+\(Format.fixed(trimCm, 1)) cm trim each side")
                MetricCard(label: "Film – baseline", value: "\(Format.fixed(r.baselineFilm)) m",
                           sub: "\(cu)\(Format.fixed(r.baselineCost)) · incl. \(Int(marginPct))% margin")
                MetricCard(label: "Film – optimised", value: "\(Format.fixed(r.nestedFilm)) m",
                           sub: "\(cu)\(Format.fixed(r.nestedCost)) · incl. \(Int(marginPct))% margin")
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowBackground(Color.clear)

            if r.savingFilm > 0 {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Nesting saving").font(.caption).foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(cu)\(Format.fixed(r.savingCost))").font(.title2.weight(.bold)).foregroundStyle(Color(hex: 0x0F6E56))
                        Text("(\(Format.fixed(r.savingFilm)) m · \(Format.fixed(r.savingPct, 1))%)").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
            Text("Net is the actual surface to be covered. Cut is the size of each piece including the trim allowance on every edge. The two film totals include the safety margin, so the figure you see is what you would order from your supplier.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private var layoutSection: some View {
        let r = result
        return Section {
            Picker("Layout", selection: $layoutTab) {
                Text("Without nesting").tag(0)
                Text("With nesting").tag(1)
            }
            .pickerStyle(.segmented)

            let segments = layoutTab == 0 ? r.baselineSegments : r.nestedSegments
            let total = layoutTab == 0 ? r.baselineFilm : r.nestedFilm
            RollBar(segments: segments, total: total)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(segments) { s in
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2).fill(Theme.chart[s.colorIndex % Theme.chart.count]).frame(width: 12, height: 12)
                        Text(s.name).font(.caption)
                        Spacer()
                        Text("\(Format.fixed(s.film)) m").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                    }
                }
            }
        } header: {
            Text("Roll layout")
        } footer: {
            Text(layoutTab == 0
                 ? "Each surface cut from its own length of roll, the way most jobs are estimated."
                 : "Smaller pieces placed alongside the offcut beside larger ones. The shorter the bar, the less film consumed, and the lower the cost.")
        }
    }

    private var breakdownSection: some View {
        let r = result
        return Section {
            ForEach(r.rows) { row in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(row.piece.name).font(.subheadline.weight(.semibold))
                        Spacer()
                        Text("Z\(row.zoneNumber)").font(.caption.weight(.bold)).foregroundStyle(Theme.accent)
                    }
                    HStack(spacing: 12) {
                        Text("\(Format.fixed(row.piece.origL)) × \(Format.fixed(row.piece.origW)) m")
                        Text("Cut \(Format.fixed(row.piece.l * row.piece.w)) m²")
                        Text("Baseline \(Format.fixed(row.baselineFilm)) m")
                    }
                    .font(.caption).foregroundStyle(.secondary)
                    HStack(spacing: 6) {
                        if row.rotated { Pill(text: "Rotated ↺", color: Color(hex: 0xBA7517)) }
                        if let host = row.nestedAlongside {
                            Pill(text: "nested alongside \(host)", color: Color(hex: 0x0F6E56))
                        } else {
                            Text("opens zone").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
            HStack {
                Text("Total (incl. \(Int(marginPct))% margin)").font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Format.fixed(r.nestedFilm)) m · \(currency.symbol)\(Format.fixed(r.nestedCost))").font(.subheadline.weight(.semibold))
            }
        } header: {
            Text("Surface breakdown")
        } footer: {
            Text("Surface by surface: the dimensions you entered, the gross area after waste, the baseline film required, and the optimisation the nesting algorithm found. \"Nested alongside\" tells you which smaller piece sits in the offcut of which larger one — useful when you mark up the roll before cutting.")
        }
    }
}

/// Horizontal stacked bar showing film consumption per piece / zone.
struct RollBar: View {
    let segments: [CoverageEngine.BarSegment]
    let total: Double

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 1) {
                ForEach(segments) { s in
                    let frac = total > 0 ? s.film / total : 0
                    Rectangle()
                        .fill(Theme.chart[s.colorIndex % Theme.chart.count])
                        .frame(width: max(2, geo.size.width * frac))
                        .overlay(alignment: .leading) {
                            Text(s.name).font(.system(size: 9, weight: .semibold)).foregroundStyle(.white)
                                .lineLimit(1).padding(.horizontal, 3)
                        }
                        .clipped()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .frame(height: 30)
    }
}

#Preview {
    NavigationStack { CoverageCalculatorView() }
}
