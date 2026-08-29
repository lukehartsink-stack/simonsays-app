import SwiftUI

struct CostLine: Identifiable, Hashable {
    let id = UUID()
    var label: String
    var amount: Double
}

struct HourlyRateCalculatorView: View {
    @State private var currency: Currency = .eur
    @State private var wageMonth: Double = 3500
    @State private var fixedLines: [CostLine] = [
        .init(label: "Rent and service charges", amount: 18000),
        .init(label: "Insurance (buildings, contents, liability)", amount: 3600),
        .init(label: "Utilities (standing + usage, all year)", amount: 6000),
        .init(label: "Equipment depreciation and replacement fund", amount: 4800),
        .init(label: "Lift servicing, compressor servicing, electrical", amount: 1200),
        .init(label: "Software, subscriptions, accountancy", amount: 2400),
        .init(label: "Marketing, ads, photography, content tools", amount: 3600),
        .init(label: "Training and certifications", amount: 1500),
        .init(label: "Vehicle costs (van, fuel, maintenance)", amount: 4500)
    ]
    @State private var variableLines: [CostLine] = [
        .init(label: "Consumables (compounds, towels, blades, tape, etc.)", amount: 6000),
        .init(label: "Waste disposal and water disposal", amount: 1200),
        .init(label: "Customer hospitality, handover bags, printing", amount: 1200)
    ]
    @State private var futurePct: Double = 15
    @State private var profitPct: Double = 10
    @State private var daysPerWeek: Double = 5
    @State private var hoursPerDay: Double = 8
    @State private var weeksPerYear: Double = 46
    @State private var nonBillablePct: Double = 35

    // MARK: Derived figures (mirrors the site's calc())
    private var wageYear: Double { wageMonth * 12 }
    private var fixedSub: Double { fixedLines.reduce(0) { $0 + $1.amount } }
    private var variableSub: Double { variableLines.reduce(0) { $0 + $1.amount } }
    private var baseSub: Double { wageYear + fixedSub + variableSub }
    private var futureVal: Double { baseSub * futurePct / 100 }
    private var profitVal: Double { baseSub * profitPct / 100 }
    private var totalBase: Double { baseSub + futureVal + profitVal }
    private var shopHours: Double { daysPerWeek * hoursPerDay * weeksPerYear }
    private var nonBillableHours: Double { shopHours * nonBillablePct / 100 }
    private var billableHours: Double { shopHours - nonBillableHours }
    private var rate: Double { billableHours > 0 ? totalBase / billableHours : 0 }
    private var dailyTarget: Double { daysPerWeek * weeksPerYear > 0 ? totalBase / (daysPerWeek * weeksPerYear) : 0 }
    private var weeklyTarget: Double { weeksPerYear > 0 ? totalBase / weeksPerYear : 0 }

    private var cu: String { currency.symbol }
    private func money(_ v: Double, _ d: Int = 0) -> String { Format.money(v, symbol: cu, decimals: d) }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("A four-layer model for a defensible rate")
                    Text("Working out the real hourly rate your PPF or detailing shop has to charge to cover every cost, pay you a proper wage, fund the future, and leave a margin on top. The handout's worked example is pre-filled to show you the structure — overwrite it line by line with your own real costs.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }

            Section {
                Picker("Currency", selection: $currency) {
                    ForEach(Currency.allCases) { c in Text(c.label).tag(c) }
                }
                NumberField(label: "Monthly gross wage", value: $wageMonth, decimals: 0)
                LabeledContent("Annual wage (× 12)", value: money(wageYear))
            } header: {
                Text("Step 1 of 5 · Layer 1 — Your wage")
            } footer: {
                Text("Start with what you need to live on. The gross monthly figure, before tax and social charges, that an employed person doing your job at your skill level would expect to earn in your country. That is your starting line, not a stretch goal.")
            }

            costLinesSection(title: "Step 2 of 5 · Layer 2 — Fixed overheads",
                             footer: "Every cost that runs whether or not you sell a single hour: rent, insurance, software, accountant, vehicle finance, loan payments. Enter annual figures. Tap a label to edit it.",
                             lines: $fixedLines, subtotalLabel: "Fixed overheads — annual subtotal", subtotal: fixedSub)

            costLinesSection(title: "Step 3 of 5 · Layer 3 — Variable & consumable costs",
                             footer: "Costs that scale with how much work you do: utilities usage, compounds, microfibres, replacement blades, waste disposal, machine wear. The easiest to underestimate because they arrive in small amounts spread across many invoices. Enter annual figures.",
                             lines: $variableLines, subtotalLabel: "Variable costs — annual subtotal", subtotal: variableSub)

            Section {
                NumberField(label: "Future fund", value: $futurePct, decimals: 0, suffix: "%")
                NumberField(label: "Profit margin", value: $profitPct, decimals: 0, suffix: "%")
                LabeledContent("Layers 1 – 3 subtotal", value: money(baseSub))
                LabeledContent("Future fund (\(Int(futurePct))%)", value: money(futureVal))
                LabeledContent("Profit margin (\(Int(profitPct))%)", value: money(profitVal))
                LabeledContent {
                    Text(money(totalBase)).font(.body.weight(.semibold))
                } label: {
                    Text("Total annual cost base").font(.body.weight(.semibold))
                }
            } header: {
                Text("Step 4 of 5 · Layer 4 — Future fund and profit margin")
            } footer: {
                Text("Two percentages, both calculated on the sum of Layers 1, 2 and 3. The future fund (10–20% is typical) pays for the equipment you have not bought yet, the savings buffer, and your first employee who will not be billable on day one. The profit margin (5–15% is typical) is what makes the business worth running over and above paying you a wage.")
            }

            Section {
                NumberField(label: "Working days per week", value: $daysPerWeek, decimals: 1)
                NumberField(label: "Hours per day", value: $hoursPerDay, decimals: 1)
                NumberField(label: "Working weeks per year", value: $weeksPerYear, decimals: 0)
                NumberField(label: "Non-billable share", value: $nonBillablePct, decimals: 0, suffix: "%")
                LabeledContent("Hours at the shop", value: Format.number(shopHours) + " h")
                LabeledContent("Non-billable hours (\(Int(nonBillablePct))%)", value: Format.number(nonBillableHours) + " h")
                LabeledContent {
                    Text(Format.number(billableHours) + " h").font(.body.weight(.semibold))
                } label: {
                    Text("Billable hours per year").font(.body.weight(.semibold))
                }
            } header: {
                Text("Step 5 of 5 · Realistic billable hours")
            } footer: {
                Text("Not the hours you spend at the shop, the hours a customer is actually paying for. A typical owner-operator finds that thirty to fifty per cent of working hours are non-billable — quotes, admin, marketing, cleaning, training, the unpaid follow-ups. Track it for a fortnight before you guess. Working weeks = 52 minus holidays, sickness, closures.")
            }

            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Defensible floor rate").font(.caption).foregroundStyle(.secondary)
                    Text(money(rate)).font(.system(size: 44, weight: .bold)).foregroundStyle(Theme.accentDeep)
                    Text("per billable hour, before VAT").font(.caption).foregroundStyle(.secondary)
                    RateRangeBar(rate: rate, symbol: cu)
                    Text("The shaded band shows the typical European range for owner-operated PPF and detailing shops, around €85 – €150 per hour, per the handout. Yours may sit higher or lower depending on country, location, and specialisation. If your current price feels far below your calculated rate, the answer is rarely work more hours — the answer is to raise the rate, slowly, while improving the customer experience that justifies it.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    MetricCard(label: "Annual cost base", value: money(totalBase), sub: "total to cover, with future fund and margin")
                    MetricCard(label: "Billable hours", value: Format.number(billableHours) + " h", sub: "per year, after non-billable share")
                    MetricCard(label: "Daily revenue target", value: money(dailyTarget), sub: "cost base ÷ working days")
                    MetricCard(label: "Weekly revenue target", value: money(weeklyTarget), sub: "cost base ÷ working weeks")
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowBackground(Color.clear)
            } header: {
                Text("Your hourly rate")
            } footer: {
                Text("Total annual cost base divided by realistic billable hours. This is the floor. Below this rate, the business is not paying for itself once everything is honestly accounted for. Above it, the business is genuinely profitable and resilient.")
            }

            Section {
                Callout("Customers buy outcomes — a fully wrapped bonnet, a paint correction, a full ceramic detail — not hours. Quote the outcome at a fixed price, calculated using your real hourly rate behind the scenes. This protects you from the customer who watches the clock, and rewards you for working efficiently. The hourly rate is the engine behind every quote, not the headline on the invoice.", title: "Reading the number")
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                DisclaimerFooter(text: "This tool is intended as a guide only. It is general guidance, not financial, tax, or business advice. For specific accounting, pricing models, or business planning, consult a qualified accountant or business adviser. All figures should be independently verified before you set or change your shop's rates. simonsays.coach accepts no liability for errors, omissions, or losses arising from reliance on the figures produced by this calculator.")
            }
        }
        .navigationTitle("Hourly Rate Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }

    private func costLinesSection(title: String, footer: String, lines: Binding<[CostLine]>, subtotalLabel: String, subtotal: Double) -> some View {
        Section {
            ForEach(lines) { $line in
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Cost line", text: $line.label).font(.subheadline)
                    HStack {
                        Text(cu).foregroundStyle(.secondary)
                        TextField("0", value: $line.amount, format: .number.precision(.fractionLength(0)))
                            .keyboardType(.numberPad)
                        Spacer()
                        Text("per year").font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { idx in lines.wrappedValue.remove(atOffsets: idx) }
            Button {
                lines.wrappedValue.append(CostLine(label: "New cost line", amount: 0))
            } label: {
                Label("Add a cost line", systemImage: "plus.circle.fill")
            }
            LabeledContent {
                Text(money(subtotal)).font(.body.weight(.semibold))
            } label: {
                Text(subtotalLabel).font(.body.weight(.semibold))
            }
        } header: {
            Text(title)
        } footer: {
            Text(footer + " Swipe left to remove a line.")
        }
    }
}

/// Axis €50–€200 with a shaded €85–€150 band and a marker for the calculated rate.
struct RateRangeBar: View {
    let rate: Double
    let symbol: String
    private let lo = 50.0, hi = 200.0, bandLo = 85.0, bandHi = 150.0

    private func pct(_ v: Double) -> Double { min(1, max(0, (v - lo) / (hi - lo))) }

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                let w = geo.size.width
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.rule).frame(height: 10)
                    Capsule().fill(Theme.accent.opacity(0.3))
                        .frame(width: w * (pct(bandHi) - pct(bandLo)), height: 10)
                        .offset(x: w * pct(bandLo))
                    Circle().fill(Theme.accentDeep).frame(width: 16, height: 16)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                        .offset(x: w * pct(rate) - 8)
                }
                .frame(height: 16)
            }
            .frame(height: 16)
            HStack {
                Text("\(symbol)50").font(.caption2).foregroundStyle(.secondary)
                Spacer()
                Text("\(symbol)200").font(.caption2).foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack { HourlyRateCalculatorView() }
}
