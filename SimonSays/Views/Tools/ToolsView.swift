import SwiftUI

struct ToolsView: View {
    private let store = DataStore.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Eyebrow("Free · No sign-up")
                        Text("A growing set of interactive tools for installers, detailers, and the customers you talk to every day.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Calculators") {
                    NavCard(badge: "Free tool", title: "PPF Coverage Calculator",
                            text: "Work out how much film a job actually consumes before you cut, so you quote material honestly.",
                            systemImage: "ruler.fill") { CoverageCalculatorView() }
                    NavCard(badge: "Free tool", title: "Hourly Rate Calculator",
                            text: "Builds a defensible hourly rate from your real cost base, using the four-layer model from handout 5.2.",
                            systemImage: "clock.fill") { HourlyRateCalculatorView() }
                }

                Section("Learning") {
                    NavCard(badge: "Live · \(store.studySet.questions.count) questions", title: "Handbook Study Set",
                            text: "Multiple-choice questions on Parts 1–3. Marks your answers and points you to the handouts to revisit.",
                            systemImage: "checkmark.circle.fill") { StudySetView() }
                    NavCard(badge: "Live · 9 tools", title: "Fun & Games",
                            text: "Drills, demos, quizzes, and games that make learning the trade less dry, from the self-heal demo to the panel-sequence puzzle.",
                            systemImage: "gamecontroller.fill") { FunAndGamesView() }
                }

                Section("The quoting tool") {
                    NavCard(badge: "Excel · Profilm Edition", title: "PPF Quote Calculator",
                            text: "Pre-loaded with film prices, hourly-rate defaults, profit margin, and VAT, so you can produce a defensible quote in minutes, not an evening.",
                            systemImage: "tablecells.fill") { QuoteCalculatorView() }
                }
            }
            .navigationTitle("Training Tools")
        }
    }
}

struct QuoteCalculatorView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("The tool")
                    Text("PPF Quote Calculator").font(.largeTitle.weight(.bold))
                    Text("A quoting tool for installers. Pre-loaded with film prices, hourly-rate defaults, profit margin, and VAT, so you can produce a defensible quote in minutes, not an evening.")
                        .font(.body).foregroundStyle(.secondary)
                }
                Text("The first version ships pre-configured for Profilm. Versions for other films (XPEL, SunTek, CovrGard) are built on request.")

                VStack(alignment: .leading, spacing: 8) {
                    Text("PPF Quote Calculator — Profilm Edition").font(.headline)
                    Text("Watermarked Excel file with personal pricing, margins, VAT and a quote dashboard built in.")
                        .font(.subheadline).foregroundStyle(.secondary)
                    EmailButton(title: "Ask about the Quote Calculator",
                                subject: "PPF Quote Calculator — Profilm Edition",
                                body: "Hi simonsays.coach Team,\n\nI would like to request the PPF Quote Calculator (Profilm Edition).\nPlease contact me with details about pricing and availability.\n\n")
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.tintBorder))

                NavigationLink {
                    QuoteGuideView()
                } label: {
                    Callout("Read the full user guide first — it shows the writing voice, demonstrates the tool itself, and runs a real quote from intake to delivered PDF.", title: "Free preview: the user guide")
                }
                .buttonStyle(.plain)

                Text("Try the free calculators first").font(.title3.weight(.semibold))
                NavigationLink("PPF Coverage Calculator") { CoverageCalculatorView() }
                NavigationLink("Hourly Rate Calculator") { HourlyRateCalculatorView() }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Quote Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ToolsView()
}
