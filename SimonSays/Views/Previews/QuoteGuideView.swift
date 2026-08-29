import SwiftUI

struct QuoteGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Free preview · Profilm Quote Calculator · EN")
                    Text("Profilm Quote Calculator user guide").font(.largeTitle.weight(.bold))
                    Text("How to build a watertight quote with the Profilm template.").font(.title3).foregroundStyle(.secondary)
                }

                Text("This guide walks you through using the Profilm Quote Calculator, the Excel template you receive from simonsays.coach, to build, present, and track every PPF quote. The template calculates material cost, plot cost, profit, installation time, services, VAT, and discounts. It produces an internal worksheet for you and a clean customer-facing quote for your client, and the dashboard keeps a running log of jobs over time.")

                section("1. The three worksheets at a glance") {
                    table([
                        ("Dashboard", "Live summary of the current quote and a manual log of past jobs. The left side updates as you fill in the Installer sheet; the right side is the job log you maintain by hand."),
                        ("Installer", "The internal worksheet. Pick materials, enter linear metres, set installation hours, apply discounts. Shows costs, margin, and profit. Never share this with the customer."),
                        ("Customer", "The customer-facing quote. Sales price for materials, installation, and services with totals; no costs, no margin. Discount lines appear automatically when a discount is applied.")
                    ])
                }

                section("2. Building a quote, step by step") {
                    Text("Always work from the Installer worksheet. The Customer and Dashboard worksheets update on their own.").font(.subheadline).foregroundStyle(.secondary)
                    numbered([
                        "In column A, type the panel or part (for example Bonnet, Front Bumper, Roof). The row goes live as soon as column A has a value.",
                        "In column B, choose the material from the dropdown.",
                        "In column D, enter the number of linear metres of film needed for that part (Linear Metre). The worksheet multiplies linear metres by roll width to calculate m².",
                        "In column N, enter the installation hours for that part (Installation hours).",
                        "Repeat for every panel on the vehicle, up to 20 line items per quote.",
                        "Below the parts table, add any extra services (wash, polish, ceramic coat, and so on) from the Additional Services dropdowns. Set Required to Yes or No and adjust the hours.",
                        "Set discounts (see Section 3).",
                        "Send the customer the Customer worksheet. Print to PDF or save it as a PDF."
                    ])
                }

                section("3. Applying a discount") {
                    Text("The discount fields sit at the bottom of the Installer worksheet, in the yellow-flagged DISCOUNTS block.").font(.subheadline).foregroundStyle(.secondary)
                    table([
                        ("PPF Discount % (cell B56)", "Lowers the combined material + installation total by this percentage. Enter as a percentage like 10% or as a decimal like 0.10."),
                        ("Services Discount % (cell B57)", "Lowers the additional-services total by this percentage. Independent of the PPF discount.")
                    ])
                    bullets([
                        ("At 0%, invisible.", "When both discounts are at 0%, the customer sees no discount lines. The Customer worksheet looks identical to a quote without a discount."),
                        ("Above 0%, automatic.", "The moment you enter a discount above 0%, the matching line appears on the Customer worksheet, showing both the percentage and the euro amount."),
                        ("VAT follows the discount.", "VAT is recalculated on the net total after discount, so the customer only pays VAT on what they actually owe."),
                        ("The Dashboard always shows the discount lines,", "even at 0%. That view is for you, not the customer.")
                    ])
                }

                section("4. Reading the Dashboard") {
                    bullets([
                        ("Left side, the current quote summary.", "Updates live as you fill in the Installer worksheet. It shows total film m², material buying price, plot cost, sales price, installation revenue, services revenue, every discount, the final totals (net, VAT, total including VAT), and your PPF margin. Use it to sanity-check a quote before you send it."),
                        ("Right side, the job log.", "A blank table you fill in by hand to track completed jobs over time. After closing out a quote, add a new row: date, customer, vehicle, m², material cost, sales price, discount, net after discount, VAT, total including VAT, profit. Totals at the bottom of the log add up across all rows, and the aggregate statistics below show your average job value and total profit.")
                    ])
                }

                section("5. Changing prices, materials, or rates") {
                    Text("The backend of the calculator holds the calculating formulas: the material buying prices, the plot-cost rate, the hourly rate, the profit margin, and the VAT rate set for your country. These are configured by simonsays.coach for your shop, and only simonsays.coach can change them.")
                    Callout("Material buying prices, hourly rate, profit margin, VAT rate, or the list of available products: email training@simonsays.coach with what you need and we send you an updated file. Keeping the price list centralised means your quotes stay accurate and current.", title: "Need to change something?")
                }

                section("6. Tips and common mistakes") {
                    bullets([
                        ("A parts row only goes live once column A holds text.", "If you forget the part name, the rest of the row stays at zero."),
                        ("Linear metres, not m².", "Enter how many metres of film come off the roll. The worksheet multiplies that by the roll width to get m²."),
                        ("Hours at 0 means €0.", "If you leave the installation hours at 0, that row stays at €0 even when the material has been calculated. Always check both column D (linear metres) and column N (hours)."),
                        ("Save a new file per customer.", "Use Save As so the main template stays clean."),
                        ("Scan before you send.", "Before sending the Customer worksheet, check the Installer worksheet for stray test rows left over from a previous quote."),
                        ("Price updates only reach new quotes.", "When you receive an updated file from simonsays.coach, every quote you build in it uses the new prices. Quotes you have already saved as separate files stay as they were.")
                    ])
                    Callout("Check the three columns first: A (part name typed?), D (linear metres entered?), N (hours entered?). Nine times out of ten one of them is empty. For anything else, email training@simonsays.coach.", title: "If a quote doesn't add up")
                }

                EmailButton(title: "Ask about the Quote Calculator",
                            subject: "PPF Quote Calculator — Profilm Edition",
                            body: "Hi simonsays.coach Team,\n\nI would like to request the PPF Quote Calculator (Profilm Edition).\nPlease contact me with details about pricing and availability.\n\n")

                DisclaimerFooter(text: "This is the full user guide that ships with the Profilm Quote Calculator, and matches the version of the file you received.")
            }
            .padding()
        }
        .navigationTitle("Quote Calculator Guide")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.title3.weight(.semibold))
            content()
        }
    }

    private func table(_ rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { i in
                VStack(alignment: .leading, spacing: 3) {
                    Text(rows[i].0).font(.subheadline.weight(.semibold))
                    Text(rows[i].1).font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                if i < rows.count - 1 { Divider() }
            }
        }
        .background(Theme.tint, in: RoundedRectangle(cornerRadius: 10))
    }

    private func numbered(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(i + 1)")
                        .font(.caption.weight(.bold))
                        .frame(width: 22, height: 22)
                        .background(Theme.accent, in: Circle())
                        .foregroundStyle(.white)
                    Text(items[i]).font(.subheadline)
                }
            }
        }
    }

    private func bullets(_ items: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .top, spacing: 8) {
                    Text("•").foregroundStyle(Theme.accent)
                    Text(items[i].0).fontWeight(.semibold) + Text(" " + items[i].1)
                }
                .font(.subheadline)
            }
        }
    }
}

#Preview {
    NavigationStack { QuoteGuideView() }
}
