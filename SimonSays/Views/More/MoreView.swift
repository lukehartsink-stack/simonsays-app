import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    LibraryRow(title: "About Simon", subtitle: "Founder and trainer · the independence note", icon: "person.crop.circle.fill", color: Theme.accent) { AboutView() }
                    LibraryRow(title: "The Handbook", subtitle: "Editions and how to get it", icon: "book.closed.fill", color: Theme.accentDeep) { HandbookContentView() }
                    LibraryRow(title: "PPF Quote Calculator", subtitle: "Excel quoting tool · Profilm edition", icon: "tablecells.fill", color: SearchKind.tool.color) { QuoteCalculatorView() }
                }
                Section("Contact") {
                    Link(destination: URL(string: "mailto:\(Theme.contactEmail)")!) {
                        Label(Theme.contactEmail, systemImage: "envelope.fill")
                    }
                    Link(destination: URL(string: "https://www.instagram.com/simoncrookes_ppf/")!) {
                        Label("Instagram @simoncrookes_ppf", systemImage: "camera.fill")
                    }
                    Link(destination: Theme.siteURL) {
                        Label("simonsays.coach", systemImage: "safari.fill")
                    }
                }
                Section {
                    Link("Legal notice", destination: URL(string: "https://simonsays.coach/legal/")!)
                    Link("Privacy", destination: URL(string: "https://simonsays.coach/privacy/")!)
                } footer: {
                    Text("Independent training and support for PPF installers and car detailers. Content and media partnership with Charlie Detailing.\n\nVersion \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"))")
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
