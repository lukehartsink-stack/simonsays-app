import SwiftUI

/// Hub for the seven product ranges plus the universal cross-range search.
struct ProductFinderView: View {
    private let ranges = DataStore.shared.productRanges
    private var total: Int { ranges.reduce(0) { $0 + $1.products.count } }

    var body: some View {
        List {
            Section {
                Text("Look up a detailing product, machine, pad or abrasive by name or by the job you're doing, and get what it's for, the right dilution or the specification, and the full method.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section {
                NavCard(badge: "Live · \(total) products", title: "Universal Product Finder",
                        text: "One full-text search across every range at once — by name, job, ingredient or dosage. Results come back grouped per range.",
                        systemImage: "globe") { ProductSearchView(ranges: ranges, title: "Universal Product Finder") }
            }
            Section("By range") {
                ForEach(ranges) { r in
                    NavCard(badge: "Live · \(r.products.count) products", title: r.label,
                            text: rangeBlurb[r.label] ?? "",
                            systemImage: rangeIcon[r.label] ?? "shippingbox.fill") {
                        ProductSearchView(ranges: [r], title: r.label)
                    }
                }
            }
            Section {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "plus.circle").font(.title2).foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("More ranges").font(.headline)
                        Text("More brands will be added the same way, each with its own searchable finder.").font(.subheadline).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Product Finder")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let rangeIcon: [String: String] = [
        "Labocosmetica": "drop.fill",
        "Ma-Fra — Car Wash Range": "bubbles.and.sparkles.fill",
        "Maniac Line": "sparkles",
        "Rupes": "gearshape.2.fill",
        "Flex": "bolt.fill",
        "Micrum": "circle.grid.3x3.fill",
        "Kovax": "square.grid.3x3.fill"
    ]

    private let rangeBlurb: [String: String] = [
        "Labocosmetica": "The full Labocosmetica range: what it is, the chemistry, where it fits the job, the dilution, tips and watch-outs.",
        "Ma-Fra — Car Wash Range": "Ma-Fra's professional Car Wash range: prewash, shampoos, wheels and tyres, waxes, interior, glass, perfumers and equipment.",
        "Maniac Line": "Ma-Fra's Maniac Line detailing range: prewash, decontamination, shampoos, protection, interior and leather, glass, cloths and car perfumes.",
        "Rupes": "Polishing machines, sanders, pads, backing plates and compounds — each card carries the specification and what it fits.",
        "Flex": "Polishing machines, backing plates, pads, vacuums and spares — movement, orbit, plate size, power.",
        "Micrum": "Dry micro-sanding system for paint defects: GRAP, MIL flexible discs, RESET film discs, plus interfaces, blocks and blades.",
        "Kovax": "Dry sanding system by line: Tolecut, Assilex, Tolex, Buflex — plus the paper, blocks, pads and tools."
    ]
}

/// Searchable list of products for one or more ranges.
struct ProductSearchView: View {
    let ranges: [ProductRange]
    let title: String

    @State private var query = ""
    @State private var area: JobArea? = nil
    @State private var category: String? = nil

    private var singleRange: ProductRange? { ranges.count == 1 ? ranges[0] : nil }

    private var terms: [String] {
        query.lowercased().split(separator: " ").map(String.init).filter { !$0.isEmpty }
    }

    private func matches(_ p: Product) -> Bool {
        if let area, !(p.u ?? []).contains(area.rawValue) { return false }
        if let category, p.c != category { return false }
        if terms.isEmpty { return true }
        let hay = p.b.isEmpty ? (p.n + " " + p.t + " " + p.c).lowercased() : p.b
        return terms.allSatisfy { hay.contains($0) }
    }

    private struct RangeResult: Identifiable {
        let range: ProductRange
        let products: [Product]
        var id: String { range.id }
    }

    private var results: [RangeResult] {
        var out: [RangeResult] = []
        for r in ranges {
            let ps = r.products.filter(matches)
            if !ps.isEmpty { out.append(RangeResult(range: r, products: ps)) }
        }
        return out
    }

    private var resultCount: Int { results.reduce(0) { $0 + $1.products.count } }

    var body: some View {
        List {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        if let r = singleRange {
                            chip("All", selected: category == nil) { category = nil }
                            ForEach(r.categories, id: \.self) { c in
                                chip(c, selected: category == c) { category = c }
                            }
                        } else {
                            chip("All jobs", selected: area == nil) { area = nil }
                            ForEach(JobArea.allCases) { a in
                                chip(a.label, selected: area == a) { area = a }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            if results.isEmpty {
                Section {
                    Text("No products match. Try a different word or clear the filters.").foregroundStyle(.secondary)
                }
            } else {
                ForEach(results) { entry in
                    Section {
                        ForEach(entry.products) { p in
                            NavigationLink {
                                ProductDetailView(product: p, rangeName: entry.range.label)
                            } label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(p.name).font(.body.weight(.medium))
                                    Text(p.tagline).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                                    Text(p.category).font(.caption2).foregroundStyle(Theme.accent)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    } header: {
                        Text("\(entry.range.label) · \(entry.products.count)")
                    }
                }
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Name, job, ingredient or dosage")
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(resultCount)").font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private func chip(_ label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.medium))
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(selected ? Theme.accent : Color(.secondarySystemGroupedBackground), in: Capsule())
                .foregroundStyle(selected ? .white : .primary)
                .overlay(Capsule().stroke(selected ? Theme.accent : Theme.rule))
        }
        .buttonStyle(.plain)
    }
}

struct ProductDetailView: View {
    let product: Product
    let rangeName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("\(rangeName) · \(product.category)")
                    Text(product.name).font(.title.weight(.bold))
                    Text(product.tagline).font(.title3).foregroundStyle(.secondary)
                }

                if let areas = product.u, !areas.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(areas, id: \.self) { a in
                            Pill(text: JobArea(rawValue: a)?.label ?? a)
                        }
                    }
                }

                if !product.details.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.detailLabel).font(.headline)
                        VStack(spacing: 0) {
                            ForEach(Array(product.details.enumerated()), id: \.offset) { i, pair in
                                HStack(alignment: .top, spacing: 12) {
                                    Text(pair.0).font(.subheadline.weight(.semibold)).frame(width: 130, alignment: .leading)
                                    Text(pair.1).font(.subheadline)
                                    Spacer(minLength: 0)
                                }
                                .padding(.vertical, 8)
                                if i < product.details.count - 1 { Divider() }
                            }
                        }
                        .padding(.horizontal, 12)
                        .background(Theme.tint, in: RoundedRectangle(cornerRadius: 10))
                    }
                }

                if let url = product.shopLink {
                    Link(destination: url) {
                        Label("View on \(url.host() ?? "supplier site")", systemImage: "cart")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                DisclaimerFooter(text: "Product details are summarised from simonsays.coach's Detailing Product Finder. Always follow the manufacturer's label and technical data sheet.")
            }
            .padding()
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { ProductFinderView() }
}
