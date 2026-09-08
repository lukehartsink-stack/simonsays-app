import SwiftUI

struct FAQView: View {
    private let data = DataStore.shared.faq
    @ObservedObject private var store = ProfileStore.shared
    @State private var query = ""
    @State private var audience = "all"
    @State private var category = "all"
    @State private var expanded: Set<String> = []

    private var categoryNames: [String: String] {
        Dictionary(uniqueKeysWithValues: data.categories.map { ($0.id, $0.name) })
    }
    private var audienceNames: [String: String] {
        Dictionary(uniqueKeysWithValues: data.audiences.map { ($0.id, $0.name) })
    }
    private var presentCategories: [FAQCategory] {
        let present = Set(data.faqs.map(\.category))
        return data.categories.filter { present.contains($0.id) }
    }

    private var filtered: [FAQItem] {
        let terms = query.lowercased().split(separator: " ").map(String.init).filter { !$0.isEmpty }
        return data.faqs.filter { f in
            if audience != "all" && f.audience != audience { return false }
            if category != "all" && f.category != category { return false }
            if terms.isEmpty { return true }
            let hay = f.searchBlob
            return terms.allSatisfy { hay.contains($0) }
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Show", selection: $audience) {
                    Text("Everything").tag("all")
                    ForEach(data.audiences) { a in Text(a.name).tag(a.id) }
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16))
                .listRowBackground(Color.clear)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        chip("All topics", id: "all")
                        ForEach(presentCategories) { c in chip(c.name, id: c.id) }
                    }
                    .padding(.horizontal, 16)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                if filtered.isEmpty {
                    Text("No questions match. Try a different word or clear the filters.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filtered) { f in
                        faqRow(f)
                    }
                }
            } header: {
                Text("\(filtered.count) \(filtered.count == 1 ? "question" : "questions")")
            } footer: {
                Text("General guidance for installers and car owners; always follow the film manufacturer's technical data sheet for a specific product, and consult your installer for your vehicle. External sources named are third-party references, not affiliated with simonsays.coach.")
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search questions")
        .navigationTitle("PPF Installation FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chip(_ label: String, id: String) -> some View {
        let on = category == id
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { category = id }
        } label: {
            Text(label)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(on ? Theme.accent : Color(.secondarySystemGroupedBackground), in: Capsule())
                .foregroundStyle(on ? .white : .primary)
                .overlay(Capsule().stroke(on ? Theme.accent : Theme.rule))
        }
        .buttonStyle(.plain)
    }

    private func faqRow(_ f: FAQItem) -> some View {
        let isOpen = expanded.contains(f.id)
        return VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isOpen { expanded.remove(f.id) } else { expanded.insert(f.id) }
                }
            } label: {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                        .rotationEffect(.degrees(isOpen ? 90 : 0))
                        .padding(.top, 4)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(f.q).font(.body.weight(.medium)).foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 6) {
                            Pill(text: categoryNames[f.category] ?? f.category)
                            Pill(text: audienceNames[f.audience] ?? f.audience,
                                 color: f.audience == "customer" ? Theme.iconSlate : Theme.iconBlue)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .buttonStyle(.plain)

            if isOpen {
                Text(f.a).font(.body)
                Button {
                    store.toggleBookmark(f.id)
                } label: {
                    Label(store.isBookmarked(f.id) ? "Saved" : "Save answer",
                          systemImage: store.isBookmarked(f.id) ? "bookmark.fill" : "bookmark")
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.borderless)
                if let refs = f.handoutRefs, !refs.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("IN THE HANDBOOK").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                        ForEach(refs, id: \.self) { r in
                            HStack(alignment: .top, spacing: 6) {
                                Text(r.ref).font(.caption.weight(.bold)).foregroundStyle(Theme.accent)
                                Text(r.title).font(.caption)
                            }
                        }
                    }
                }
                if let sources = f.sources, !sources.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SOURCES").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                        ForEach(sources, id: \.self) { s in
                            if let u = s.url, let url = URL(string: u) {
                                Link(s.label, destination: url).font(.caption)
                            } else {
                                Text(s.label).font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack { FAQView() }
}
