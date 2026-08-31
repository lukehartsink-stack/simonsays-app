import SwiftUI

/// Everything to read, browse, or calculate, in one place.
struct LibraryView: View {
    private let store = DataStore.shared

    var body: some View {
        NavigationStack {
            List {
                Section("Support") {
                    LibraryRow(title: "PPF Installation FAQ", subtitle: "\(store.faq.faqs.count) questions · filter by topic", icon: "questionmark.bubble.fill", color: SearchKind.faq.color) { FAQView() }
                    LibraryRow(title: "Detailing Product Finder", subtitle: "\(store.allProducts.count) products across 7 ranges", icon: "shippingbox.fill", color: SearchKind.product.color) { ProductFinderView() }
                    LibraryRow(title: "PPF Guide for Car Owners", subtitle: "Cost, timing, choosing an installer", icon: "car.fill", color: SearchKind.guide.color) { CarOwnerGuideView() }
                }
                Section("Handbook") {
                    LibraryRow(title: "The Handbook", subtitle: "43 handouts in six parts · two editions", icon: "book.closed.fill", color: Theme.accent) { HandbookContentView() }
                    LibraryRow(title: "Study Set", subtitle: "\(store.studySet.questions.count) questions on Parts 1–3", icon: "checkmark.circle.fill", color: Theme.green) { StudySetView() }
                }
                Section("Calculators & tools") {
                    LibraryRow(title: "PPF Coverage Calculator", subtitle: "How much film a job actually consumes", icon: "ruler.fill", color: SearchKind.tool.color) { CoverageCalculatorView() }
                    LibraryRow(title: "Hourly Rate Calculator", subtitle: "A defensible rate from your real cost base", icon: "clock.fill", color: Theme.accentDeep) { HourlyRateCalculatorView() }
                    LibraryRow(title: "PPF Quote Calculator", subtitle: "Excel quoting tool · Profilm edition", icon: "tablecells.fill", color: SearchKind.tool.color) { QuoteCalculatorView() }
                    LibraryRow(title: "Fun & Games", subtitle: "9 drills, demos, quizzes and games", icon: "gamecontroller.fill", color: Theme.purple) { FunAndGamesView() }
                }
                Section("Free previews") {
                    LibraryRow(title: "2.9 Lifting Edges — Decision Tree", subtitle: "Six questions, four root causes", icon: "arrow.triangle.branch", color: SearchKind.guide.color) { LiftingEdgesView() }
                    LibraryRow(title: "Quote Calculator User Guide", subtitle: "Building a quote with the Profilm template", icon: "doc.text.fill", color: SearchKind.tool.color) { QuoteGuideView() }
                }
                Section("Kit") {
                    LibraryRow(title: "PPF Shopping List", subtitle: "Tools and chemicals Simon uses", icon: "cart.fill", color: Theme.accentDeep) { ShoppingListView() }
                }
            }
            .navigationTitle("Library")
        }
    }
}

/// Settings-style row: coloured icon square + title + subtitle.
struct LibraryRow<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(color, in: RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.body)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    LibraryView()
}
