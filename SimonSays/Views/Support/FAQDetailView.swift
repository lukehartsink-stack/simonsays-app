import SwiftUI

/// A single FAQ answer as its own screen (used from search results).
struct FAQDetailView: View {
    let item: FAQItem
    @ObservedObject private var store = ProfileStore.shared
    private let data = DataStore.shared.faq

    private var categoryName: String {
        data.categories.first { $0.id == item.category }?.name ?? item.category
    }
    private var audienceName: String {
        data.audiences.first { $0.id == item.audience }?.name ?? item.audience
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 6) {
                    Pill(text: categoryName)
                    Pill(text: audienceName, color: item.audience == "customer" ? Theme.iconSlate : Theme.iconBlue)
                }
                Text(item.q).font(.title2.weight(.bold)).fixedSize(horizontal: false, vertical: true)
                Text(item.a).font(.body).fixedSize(horizontal: false, vertical: true)

                if let refs = item.handoutRefs, !refs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("In the handbook").font(.headline)
                        ForEach(refs, id: \.self) { r in
                            HStack(alignment: .top, spacing: 10) {
                                Text(r.ref).font(.subheadline.weight(.bold)).foregroundStyle(Theme.accent).frame(width: 36, alignment: .leading)
                                Text(r.title).font(.subheadline)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.tint, in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                if let sources = item.sources, !sources.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sources").font(.headline)
                        ForEach(sources, id: \.self) { s in
                            if let u = s.url, let url = URL(string: u) {
                                Link(destination: url) {
                                    Label(s.label, systemImage: "link").font(.subheadline)
                                }
                            } else {
                                Text(s.label).font(.subheadline)
                            }
                        }
                    }
                }

                if item.category == "edges" {
                    NavigationLink {
                        LiftingEdgesView()
                    } label: {
                        Callout("Open the Lifting Edges decision tree to diagnose it step by step.", title: "Lifting edge?")
                    }
                    .buttonStyle(.plain)
                }

                DisclaimerFooter(text: "General guidance; always follow the film manufacturer's technical data sheet for a specific product.")
            }
            .padding()
        }
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.toggleBookmark(item.id)
                } label: {
                    Image(systemName: store.isBookmarked(item.id) ? "bookmark.fill" : "bookmark")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: "Q: \(item.q)\n\nA: \(item.a)\n\n— simonsays.coach PPF Installation FAQ") {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}
