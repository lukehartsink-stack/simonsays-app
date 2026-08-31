import SwiftUI

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
    NavigationStack { AboutView() }
}
