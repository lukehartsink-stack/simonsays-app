import SwiftUI

/// First screen: one search box over everything, plus quick actions and recent searches.
struct SearchHomeView: View {
    @State private var query = ""
    @State private var scope: SearchScope = .all
    @AppStorage("recentSearches") private var recentData = Data()

    private let index = SearchIndex.shared
    private let store = DataStore.shared

    private var trimmed: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var results: [SearchIndex.Group] { index.search(trimmed, scope: scope) }

    private var recents: [String] {
        (try? JSONDecoder().decode([String].self, from: recentData)) ?? []
    }

    private func remember(_ q: String) {
        let q = q.trimmingCharacters(in: .whitespacesAndNewlines)
        guard q.count > 1 else { return }
        var list = recents.filter { $0.caseInsensitiveCompare(q) != .orderedSame }
        list.insert(q, at: 0)
        if list.count > 8 { list = Array(list.prefix(8)) }
        recentData = (try? JSONEncoder().encode(list)) ?? Data()
    }

    private func clearRecents() { recentData = Data() }

    private let popular = ["lifting edges", "bubbles", "slip solution", "post heat", "IPA", "matt film", "ceramic coating", "washing", "iron fallout", "polish pad", "hourly rate", "warranty"]

    var body: some View {
        NavigationStack {
            Group {
                if trimmed.isEmpty {
                    landing
                } else {
                    resultsList
                }
            }
            .navigationTitle("simonsays.coach")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search FAQ, products, tools, handbook…")
            .searchScopes($scope, activation: .onSearchPresentation) {
                ForEach(SearchScope.allCases) { s in Text(s.label).tag(s) }
            }
            .onSubmit(of: .search) { remember(query) }
            .navigationDestination(for: SearchEntry.ID.self) { id in
                if let entry = index.entries.first(where: { $0.id == id }) {
                    SearchDestinationView(destination: entry.destination)
                }
            }
        }
    }

    // MARK: Landing (no query)

    private var landing: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("What do you need?").font(.title2.weight(.bold))
                    Text("Answers when you're stuck. Training when you're ready.").font(.subheadline).foregroundStyle(.secondary)
                }

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ActionTile(title: "Fix a problem", subtitle: "\(store.faq.faqs.count) FAQ answers", icon: "questionmark.bubble.fill", color: SearchKind.faq.color) { FAQView() }
                    ActionTile(title: "Find a product", subtitle: "\(store.allProducts.count) products, 7 ranges", icon: "shippingbox.fill", color: SearchKind.product.color) { ProductFinderView() }
                    ActionTile(title: "Lifting edge?", subtitle: "Diagnose in six questions", icon: "arrow.triangle.branch", color: SearchKind.guide.color) { LiftingEdgesView() }
                    ActionTile(title: "How much film?", subtitle: "Coverage calculator", icon: "ruler.fill", color: SearchKind.tool.color) { CoverageCalculatorView() }
                    ActionTile(title: "What to charge", subtitle: "Hourly rate calculator", icon: "clock.fill", color: Theme.accentDeep) { HourlyRateCalculatorView() }
                    ActionTile(title: "Test yourself", subtitle: "\(store.studySet.questions.count)-question study set", icon: "checkmark.circle.fill", color: Color(hex: 0x0F6E56)) { StudySetView() }
                }

                if !recents.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Recent").font(.headline)
                            Spacer()
                            Button("Clear", action: clearRecents).font(.subheadline)
                        }
                        VStack(spacing: 0) {
                            ForEach(recents, id: \.self) { r in
                                Button {
                                    query = r
                                } label: {
                                    HStack {
                                        Image(systemName: "clock.arrow.circlepath").foregroundStyle(.secondary)
                                        Text(r).foregroundStyle(.primary)
                                        Spacer()
                                        Image(systemName: "arrow.up.left").font(.caption).foregroundStyle(.tertiary)
                                    }
                                    .padding(.vertical, 10)
                                }
                                .buttonStyle(.plain)
                                if r != recents.last { Divider() }
                            }
                        }
                        .padding(.horizontal, 14)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Popular searches").font(.headline)
                    FlowLayout(spacing: 8) {
                        ForEach(popular, id: \.self) { p in
                            Button { query = p } label: {
                                Text(p)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12).padding(.vertical, 7)
                                    .background(Color(.secondarySystemGroupedBackground), in: Capsule())
                                    .overlay(Capsule().stroke(Theme.rule))
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Text("Written by a trainer · Trusted by installers. Independent — funded by users, not manufacturers.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: Results

    private var resultsList: some View {
        Group {
            if results.isEmpty {
                ContentUnavailableView.search(text: trimmed)
            } else {
                List {
                    ForEach(results) { group in
                        Section {
                            ForEach(group.hits) { hit in
                                NavigationLink(value: hit.id) {
                                    SearchRow(entry: hit)
                                }
                            }
                        } header: {
                            Label(group.kind.label, systemImage: group.kind.icon)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .onAppear { remember(trimmed) }
            }
        }
    }
}

struct SearchRow: View {
    let entry: SearchEntry
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: entry.kind.icon)
                .font(.body)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(entry.kind.color, in: RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.title).font(.body).lineLimit(2)
                Text(entry.subtitle).font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
        }
        .padding(.vertical, 2)
    }
}

/// Resolves a search destination to its screen.
struct SearchDestinationView: View {
    let destination: SearchDestination

    var body: some View {
        switch destination {
        case .faq(let item): FAQDetailView(item: item)
        case .product(let p, let range): ProductDetailView(product: p, rangeName: range)
        case .handbook: HandbookContentView()
        case .coverageCalculator: CoverageCalculatorView()
        case .hourlyRateCalculator: HourlyRateCalculatorView()
        case .studySet: StudySetView()
        case .funAndGames: FunAndGamesView()
        case .liftingEdges: LiftingEdgesView()
        case .quoteGuide: QuoteGuideView()
        case .carOwnerGuide: CarOwnerGuideView()
        case .productFinder: ProductFinderView()
        case .shoppingList: ShoppingListView()
        case .faqList: FAQView()
        }
    }
}

/// Big tappable tile for the landing grid.
struct ActionTile<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(color, in: RoundedRectangle(cornerRadius: 10))
                Spacer(minLength: 0)
                Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                Text(subtitle).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

/// Simple wrapping layout for chips.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for s in subviews {
            let size = s.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for s in subviews {
            let size = s.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX; y += rowHeight + spacing; rowHeight = 0
            }
            s.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    SearchHomeView()
}
