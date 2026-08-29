import SwiftUI

struct SupportView: View {
    private let store = DataStore.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Eyebrow("Straight answers")
                        Text("Stuck on a job, choosing a product, or fielding a question from a customer? The Support area has reference you can trust.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                Section {
                    NavCard(badge: "Live · \(store.faq.faqs.count) questions", title: "PPF Installation FAQ",
                            text: "What installers and car owners ask most: lifting edges, bubbles, stretch and heat, surface prep, aftercare. Filter by who it's for and by topic.",
                            systemImage: "questionmark.bubble.fill") { FAQView() }
                    NavCard(badge: "Live · For car owners", title: "PPF Guide for Car Owners",
                            text: "What PPF costs and how to choose an installer: what drives the price, how long the job really takes, how to read two quotes side by side.",
                            systemImage: "car.fill") { CarOwnerGuideView() }
                    NavCard(badge: "Live · \(store.allProducts.count) products", title: "Detailing Product Finder",
                            text: "Seven ranges: Labocosmetica, Ma-Fra Car Wash, Maniac Line, Rupes, Flex, Micrum and Kovax — searchable one by one or all at once.",
                            systemImage: "magnifyingglass") { ProductFinderView() }
                }
                Section {
                    Callout("simonsays.coach is funded by users only. It takes no money, sponsorship, or material support from PPF manufacturers or distributors in exchange for visibility, ranking, or endorsement.", title: "The independence promise")
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Support")
        }
    }
}
