import SwiftUI

struct HomeView: View {
    let selectTab: (AppTab) -> Void
    private let store = DataStore.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    hero
                    quickLinks
                    audience
                    independence
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("simonsays.coach")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Eyebrow("Written by a trainer · Trusted by installers")
            Text("Independent PPF training for installers and detailers")
                .font(.largeTitle.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
            Text("Answers when you're stuck. Training when you're ready.")
                .font(.title3)
                .foregroundStyle(Theme.accentDeep)
            Text("Practical paint protection film training from someone who installed film for a living and now trains the people who do. A free support library for the problems that come up mid-job, a handbook that covers installation from prep to handover, and working calculators for quoting and film coverage.")
                .font(.body)
                .foregroundStyle(.secondary)
            HStack {
                Button { selectTab(.support) } label: {
                    Text("Find an answer").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                Button { selectTab(.handbook) } label: {
                    Text("See the handbook").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 4)
        }
    }

    private var quickLinks: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Straight to it").font(.title2.weight(.semibold))
            VStack(spacing: 0) {
                NavCard(badge: "Live · \(store.faq.faqs.count) questions", title: "PPF Installation FAQ",
                        text: "Lifting edges, bubbles, stretch and heat, surface prep, aftercare — every answer linked back to the handbook.",
                        systemImage: "questionmark.bubble.fill") { FAQView() }
                Divider()
                NavCard(badge: "Live · \(store.allProducts.count) products", title: "Detailing Product Finder",
                        text: "Look up a product, machine, pad or abrasive by name or by the job you're doing.",
                        systemImage: "magnifyingglass") { ProductFinderView() }
                Divider()
                NavCard(badge: "Free tool", title: "PPF Coverage Calculator",
                        text: "Work out how much film a job actually consumes before you cut.",
                        systemImage: "ruler.fill") { CoverageCalculatorView() }
                Divider()
                NavCard(badge: "Free tool", title: "Hourly Rate Calculator",
                        text: "A defensible hourly rate from your real cost base, using the four-layer model from handout 5.2.",
                        systemImage: "clock.fill") { HourlyRateCalculatorView() }
                Divider()
                NavCard(badge: "Live · \(store.studySet.questions.count) questions", title: "Handbook Study Set",
                        text: "Multiple-choice questions on Parts 1–3. Marks your answers and points you to the handouts to revisit.",
                        systemImage: "checkmark.circle.fill") { StudySetView() }
            }
            .padding(.horizontal, 12)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private var audience: some View {
        VStack(alignment: .leading, spacing: 10) {
            Eyebrow("Who it's for")
            Text("Small shops, big skills, thin on training").font(.title2.weight(.semibold))
            Text("Skilled tradespeople running small detailing and PPF shops across Belgium, the Netherlands, and the German-speaking countries. Excellent with their hands, often under-trained on the business side.")
                .font(.body).foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                audienceTile("Solo detailers", "Working alone, picking up PPF on top of detailing, learning each panel as it comes.", "person.fill")
                audienceTile("Shop owners", "Investing in training for the team and looking for material that holds up on the business side.", "building.2.fill")
                audienceTile("Beginners", "Fitting their first PPF and wanting reference material that explains the why, not only the how.", "sparkles")
                audienceTile("Experienced installers", "Years on the tools, sharpening technique on edge work, panel stretch, and the long-running questions.", "medal.fill")
            }
        }
    }

    private func audienceTile(_ title: String, _ text: String, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon).foregroundStyle(Theme.accent)
            Text(title).font(.subheadline.weight(.semibold))
            Text(text).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private var independence: some View {
        Callout("simonsays.coach is funded by users only. It takes no money, sponsorship, or material support from PPF manufacturers or distributors in exchange for visibility, ranking, or endorsement. Loyalty is to the truth, not to the highest bidder.",
                title: "The independence promise")
    }
}

#Preview {
    HomeView(selectTab: { _ in })
}
