import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Free previews") {
                    NavCard(badge: "Workshop reference", title: "2.9 Lifting Edges — Decision Tree",
                            text: "Two pages, in-the-bay diagnostic. Six questions route to the four root causes of edge lift.",
                            systemImage: "arrow.triangle.branch") { LiftingEdgesView() }
                    NavCard(badge: "Calculator", title: "PPF Quote Calculator User Guide",
                            text: "The full user guide for the calculator product, running a real quote from intake to delivered PDF.",
                            systemImage: "doc.text.fill") { QuoteGuideView() }
                }
                Section("Kit") {
                    NavCard(badge: "Tools, chemicals, training", title: "PPF Shopping List",
                            text: "A working list of the kit Simon uses for paint protection film installation.",
                            systemImage: "cart.fill") { ShoppingListView() }
                }
                Section("About") {
                    NavCard(title: "About Simon", text: "Founder and trainer. Track record, the independence note, languages, contact.",
                            systemImage: "person.crop.circle.fill") { AboutView() }
                    Link(destination: Theme.siteURL) {
                        Label("simonsays.coach", systemImage: "safari")
                    }
                    Link(destination: URL(string: "https://www.instagram.com/simoncrookes_ppf/")!) {
                        Label("Instagram @simoncrookes_ppf", systemImage: "camera")
                    }
                    Link(destination: URL(string: "mailto:\(Theme.contactEmail)")!) {
                        Label(Theme.contactEmail, systemImage: "envelope")
                    }
                }
                Section {
                    Link("Legal notice", destination: URL(string: "https://simonsays.coach/legal/")!)
                    Link("Privacy", destination: URL(string: "https://simonsays.coach/privacy/")!)
                } footer: {
                    Text("Independent training and support for PPF installers and car detailers. Content and media partnership with Charlie Detailing.")
                }
            }
            .navigationTitle("More")
        }
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("About")
                    Text("About Simon").font(.largeTitle.weight(.bold))
                }
                Prose("Founder and trainer", [
                    "Specialises in PPF installation training and shop-business coaching for small and mid-size detailers across the Benelux and DACH regions."
                ])
                Prose("Track record", [
                    "Previously trained installers on the PremiumShield, CovrGard, and Flexishield PPF systems. Currently a trainer on the Profilm system, distributed in the Netherlands and Belgium by Glansz BV, where Simon holds a day role."
                ])
                Callout("simonsays.coach is funded by users only. It takes no money, sponsorship, or material support from PPF manufacturers or distributors in exchange for visibility, ranking, or endorsement. Loyalty is to the truth, not to the highest bidder.", title: "The independence note")
                Prose("Languages", [
                    "Trains in German and English. Dutch coming — misschien, op een dag..."
                ])
                VStack(alignment: .leading, spacing: 8) {
                    Text("Get in touch").font(.title3.weight(.semibold))
                    Text("Booking and contact — \(Theme.contactEmail).")
                    EmailButton(title: "Email Simon", subject: "Training enquiry", body: "Hi Simon,\n\n")
                }
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MoreView()
}
