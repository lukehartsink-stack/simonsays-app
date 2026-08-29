import SwiftUI

struct CarOwnerGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Support · For car owners")
                    Text("PPF Guide for Car Owners").font(.largeTitle.weight(.bold))
                    Text("What PPF costs and how to choose an installer: why prices vary, what a fair quote includes, and how to spot a careful shop.")
                        .font(.title3).foregroundStyle(.secondary)
                }

                Text("A PPF quote can vary a lot from one shop to the next, and the cheapest is rarely the best value. This guide explains what actually drives the price, what a complete quote should spell out, how long the job really takes, and the questions that separate a careful installer from a quick one. It is written for car owners deciding where to spend.")

                Prose("What drives the price", [
                    "Four things move a PPF price: how much of the car you cover, the car itself, the film, and the installer. Coverage is the biggest lever, so a partial front costs a fraction of a full-body wrap. After that comes the size of the vehicle and how complex its panels are to wrap, then the grade of film, then the prep time and skill of the shop. A cheap quote usually means one of those has been cut: less coverage, a lesser film, or less time on the prep you cannot see but that decides whether the job lasts."
                ])
                Prose("Is PPF worth it for you?", [
                    "It depends on the car and how you use it. On a car you will keep, drive on chip-heavy roads, or that holds its value, PPF protects paint that is expensive to repair and can help at resale, because the film takes the damage instead of the panel. On an older car you will sell soon, a full wrap rarely pays back, and a partial front may be plenty. A good installer will tell you where the money is well spent and where it is not, rather than selling you the biggest package."
                ])
                Prose("How long the job takes", [
                    "Plan on roughly one to two days for a full front, and three to seven days for a full-car wrap, depending on the vehicle and how many pieces it takes. That is the installation time; the film then keeps curing after you collect it. A shop that quotes a couple of hours for a full front is either doing a very small job or rushing the prep and post-heating that make it last. For anything bigger than a few door edges, leave the car rather than waiting, so the work is not fighting the clock. Ask for the expected collection day when you book."
                ])
                Prose("Reading two different quotes", [
                    "When one shop quotes half what another does, it is usually one of four things: less coverage than you think, a cheaper film that yellows or lasts fewer years, less prep and post-heat time, or a less experienced fitter. None of that shows on day one; it shows in year three, when an edge lifts or the film hazes. Get every quote to spell out the exact panels, the film brand and its warranty, and whether the edges are trimmed or wrapped, then compare like for like. Matched-up quotes tell you the real difference; the cheapest and the dearest can both be wrong."
                ])
                Prose("What a good quote includes", [
                    "A complete quote names the exact panels and coverage, the film brand and tier, and the edge finish (trimmed, with a small gap, or fully wrapped). It should also set out the two warranties you are buying: the film maker's product warranty, which typically covers yellowing, cracking and delamination for a set number of years, and the installer's workmanship guarantee on the fit. Ask what each one covers, for how long, and what voids it, and get it in writing with the invoice rather than as a verbal promise."
                ])
                Prose("Choosing the installer", [
                    "PPF wants a clean, enclosed, temperature-controlled bay, not a driveway, because dust, bugs, cold and wind are exactly what cause faults under the film. Ask to see previous work and look closely at the edges and tucks. A good installer is happy to tell you where your money is not worth spending, and will note the exact film and finish used so a later addition can be matched. You can protect the highest-wear areas now and add panels later; staging the work does not reduce the protection on what is already done. Keep all the paperwork, because proof the car has been protected helps at resale."
                ])

                VStack(alignment: .leading, spacing: 10) {
                    Text("Questions to ask before you book").font(.title3.weight(.semibold))
                    Text("A shop that answers these plainly, and puts them in writing, is the one to trust:")
                    ForEach(Array(questions.enumerated()), id: \.offset) { i, q in
                        HStack(alignment: .top, spacing: 10) {
                            Text("\(i + 1)")
                                .font(.caption.weight(.bold))
                                .frame(width: 22, height: 22)
                                .background(Theme.accent, in: Circle())
                                .foregroundStyle(.white)
                            Text(q)
                        }
                    }
                }

                NavigationLink {
                    FAQView()
                } label: {
                    Callout("Already had PPF fitted and wondering what's normal? See the PPF Installation FAQ — 100 answers on bubbles, lifting edges, aftercare and more.")
                }
                .buttonStyle(.plain)

                DisclaimerFooter(text: "simonsays.coach Support — buyer's guide. General guidance for car owners; your installer can advise on your specific vehicle, and warranty terms vary by film maker and shop.")
            }
            .padding()
        }
        .navigationTitle("Car Owner Guide")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let questions = [
        "Exactly which panels are covered?",
        "Which film brand, and what does its warranty cover and for how long?",
        "Are the edges trimmed or fully wrapped?",
        "Where is the work done, and at what temperature?",
        "When do I collect the car?",
        "What does your workmanship guarantee cover if something lifts?"
    ]
}

#Preview {
    NavigationStack { CarOwnerGuideView() }
}
