import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("About the author")
                    Text("Simon Crookes").font(.largeTitle.weight(.bold))
                    Text("Founder of simonsays.coach. PPF trainer, installer, and the person writing every page of this app.")
                        .font(.title3).foregroundStyle(.secondary)
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
                VStack(alignment: .leading, spacing: 10) {
                    Text("Get in touch").font(.title3.weight(.semibold))
                    Text("Booking and contact — \(Theme.contactEmail).")
                    EmailButton(title: "Email Simon", subject: "Training enquiry", body: "Hi Simon,\n\n")
                    VStack(spacing: 0) {
                        contactRow("Instagram", detail: "@simoncrookes_ppf", icon: "camera.fill", url: Theme.instagramURL)
                        Divider()
                        contactRow("Website", detail: "simonsays.coach", icon: "safari.fill", url: Theme.siteURL)
                    }
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("About the author")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func contactRow(_ title: String, detail: String, icon: String, url: URL) -> some View {
        Link(destination: url) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.body).foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(Theme.iconBlue, in: RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(.body).foregroundStyle(.primary)
                    Text(detail).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "arrow.up.right").font(.caption).foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
        }
    }
}

#Preview {
    NavigationStack { AboutView() }
}
