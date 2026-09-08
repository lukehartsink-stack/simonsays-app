import SwiftUI

struct HandbookPart: Identifiable {
    let number: Int
    let title: String
    let inside: String
    let fullOnly: Bool
    var id: Int { number }
}

struct HandbookContentView: View {
    private let parts: [HandbookPart] = [
        .init(number: 1, title: "Foundations",
              inside: "The chemistry and material knowledge to have before touching a panel: PPF materials, adhesives, matt vs gloss, the physics of adhesion.", fullOnly: false),
        .init(number: 2, title: "Installation Workflow",
              inside: "The job from car-arrives to car-leaves. SOPs for intake, prep, install, and QC. Panel-stretch and lifting-edges references.", fullOnly: false),
        .init(number: 3, title: "Customer Lifecycle",
              inside: "Handover, customer expectations, warranty law for the UK and EU, and a claim-handling playbook.", fullOnly: false),
        .init(number: 4, title: "Reference Forms",
              inside: "Fillable templates the shop uses every day: vehicle intake form, QC sign-off, customer care card.", fullOnly: false),
        .init(number: 5, title: "Business Operations",
              inside: "Owner-track material: finance, hourly rates, hiring, marketing, the Veblen positioning track, quoting, invoicing, complaints.", fullOnly: true),
        .init(number: 6, title: "Protecting the Business",
              inside: "What happens when something goes wrong that isn't a film failure: insurance cover, damage to a customer's car, booking terms and cancellations, the cost of a warranty claim, unpaid invoices, customer data.", fullOnly: true)
    ]

    var body: some View {
        ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Eyebrow("The handbook")
                        Text("43 handouts in six parts").font(.largeTitle.weight(.bold))
                        Text("Two editions, one source. Read on the phone, print as a bound copy, or keep both.")
                            .font(.title3).foregroundStyle(.secondary)
                    }

                    VStack(spacing: 10) {
                        ForEach(parts) { p in partRow(p) }
                    }

                    VStack(spacing: 12) {
                        editionCard(
                            title: "Installer Edition",
                            text: "Parts 1–4. Everything a trainee needs from first day on the floor to a clean customer handover.",
                            subject: "Handbook Installer Edition",
                            body: "Hi simonsays.coach Team,\n\nI would like to have more information about receiving the Installer Edition Handbook.\nPlease contact me with details about pricing and availability.\n\n"
                        )
                        editionCard(
                            title: "Full Edition",
                            text: "Parts 1–6. The installer material plus the business operations, positioning and risk track for shop owners.",
                            subject: "Handbook Full Edition",
                            body: "Hi simonsays.coach Team,\n\nI would like to have more information about receiving the Full Edition Handbook.\nPlease contact me with details about pricing and availability.\n\n"
                        )
                    }

                    Text("Each handout is also separately distributable as a self-contained PDF. Take the full binder, or pick the chapters that match where you are right now.")
                        .font(.subheadline).foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Try the free previews first").font(.title3.weight(.semibold))
                        NavigationLink {
                            LiftingEdgesView()
                        } label: {
                            previewRow("2.9 Lifting Edges — Decision Tree", "Two pages, in-the-bay diagnostic. Six questions route to the four root causes of edge lift.", "arrow.triangle.branch")
                        }
                        NavigationLink {
                            QuoteGuideView()
                        } label: {
                            previewRow("PPF Quote Calculator User Guide", "The full user guide for the calculator product, running a real quote from intake to delivered PDF.", "doc.text")
                        }
                        NavigationLink {
                            StudySetView()
                        } label: {
                            previewRow("Handbook Study Set", "88 multiple-choice questions on Parts 1–3 that mark your answers and point you back to the handouts.", "checkmark.circle")
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Handbook")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func partRow(_ p: HandbookPart) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(p.number)")
                .font(.title3.weight(.bold))
                .frame(width: 40, height: 40)
                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(p.title).font(.headline)
                    Spacer()
                    Pill(text: p.fullOnly ? "Full only" : "Installer + Full",
                         color: p.fullOnly ? Theme.iconSlate : Theme.iconBlue)
                }
                Text(p.inside).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private func editionCard(title: String, text: String, subject: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.title3.weight(.semibold))
            Text(text).font(.subheadline).foregroundStyle(.secondary)
            EmailButton(title: "Ask about the \(title)", subject: subject, body: body)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.tintBorder))
    }

    private func previewRow(_ title: String, _ text: String, _ icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(Theme.accent).frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                Text(text).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack { HandbookContentView() }
}
