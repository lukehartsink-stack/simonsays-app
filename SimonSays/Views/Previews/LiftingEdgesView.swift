import SwiftUI

/// Interactive version of handout 2.9 — six questions routing to four root causes.
struct LiftingEdgesView: View {
    enum Step: Hashable { case q1, q2, q3, q4, q5, q6, result(String, String, String) }

    struct Node {
        let question: String
        let note: String?
        let yes: Outcome
        let no: Outcome
    }
    enum Outcome {
        case go(Step)
        case verdict(title: String, text: String, train: String)
    }

    @State private var step: Step = .q1
    @State private var history: [Step] = []
    @State private var mode = 0

    private let nodes: [Step: Node] = [
        .q1: Node(question: "Did the lifting appear within 24 hours of installation?", note: nil,
                  yes: .go(.q2), no: .go(.q4)),
        .q2: Node(question: "Is the lifting on a curved area, edge, or relief cut?", note: "Likely a stretch or tack problem: memory pull-back or a weak initial bond.",
                  yes: .verdict(title: "Over-stretched film pulling back",
                                text: "The film was stretched past its memory limit and is contracting. Action: re-lift, relax the film, re-position with less stretch, post-heat to set.",
                                train: "Stretch only what the panel demands, not more."),
                  no: .go(.q3)),
        .q3: Node(question: "Was post-installation heat applied to set the film, especially on stretched zones?", note: nil,
                  yes: .verdict(title: "Under-heated",
                                text: "Heat was applied, so check temperature and dwell time: it was likely under-heated. Action: re-heat to 80–90 °C surface temperature, measured at the film with an IR thermometer (check the film's TDS), with even pressure for full activation.",
                                train: "Measure the film, not the air."),
                  no: .verdict(title: "No post-heat — this is your cause",
                               text: "The adhesive never fully activated on the stretched zones. Action: post-heat now if the film is still salvageable; otherwise replace the section.",
                               train: "Stretch + heat = permanent. Stretch without heat = temporary.")),
        .q4: Node(question: "Was the panel polished, waxed, or detailed before installation without a proper degrease afterwards?",
                  note: "Likely a surface prep or activation problem: the bond never formed properly. Polishing is a mandatory prep step — the mistake is skipping the degrease that clears the residue the polish leaves behind.",
                  yes: .verdict(title: "Silicone or oil residue blocking the bond",
                                text: "High probability of residue: Van der Waals contact never happened. Action: remove the film, do a full IPA degrease in multiple passes, reinstall.",
                                train: "Polish residue is invisible. The panel looks clean, but molecularly it isn't."),
                  no: .go(.q5)),
        .q5: Node(question: "Was the final pre-installation wipe done with IPA or a proper panel wipe, not just slip solution or water?", note: nil,
                  yes: .go(.q6),
                  no: .verdict(title: "Final wipe wasn't a degreaser — this is your cause",
                               text: "Slip solution and water do not remove oils, so the adhesive bonded to a contaminated surface. Action: remove, IPA wipe, reinstall.",
                               train: "The last wipe before film must be a degreaser, every time.")),
        .q6: Node(question: "Was the slip solution mix correct, and was enough squeegee pressure used to push it all out?", note: nil,
                  yes: .verdict(title: "Adhesion-activation timing issue",
                                text: "Too much slip left under the film, or a zone was lifted again after it had already tacked, which stretches the piece and picks up contamination. (Repositioning while the film floats on slip is not the problem; lifting tacked zones is.) Action: replace the section, install with the correct slip ratio and firm, overlapping squeegee passes, and stop lifting once a zone is tacked.",
                                train: "Once it's tacked, leave it."),
                  no: .verdict(title: "Slip solution problem confirmed",
                               text: "Too much slip left under the film means a weak bond; too little means poor positioning and stretch marks. Action: re-mix to the manufacturer ratio, re-install, and squeegee until the slip is fully evacuated.",
                               train: "Mix to the ratio; squeegee until it's dry."))
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Free preview · Installation Workflow · 2.9")
                    Text("Lifting Edges Decision Tree").font(.largeTitle.weight(.bold))
                    Text("Six diagnostic questions routing to the four root causes of edge lift.")
                        .font(.title3).foregroundStyle(.secondary)
                }

                Picker("Mode", selection: $mode) {
                    Text("Diagnose").tag(0)
                    Text("Reference").tag(1)
                }
                .pickerStyle(.segmented)

                if mode == 0 { diagnose } else { reference }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("2.9 Lifting Edges")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Interactive tree

    private var diagnose: some View {
        VStack(alignment: .leading, spacing: 16) {
            fourCauses

            switch step {
            case .result(let title, let text, let train):
                VStack(alignment: .leading, spacing: 10) {
                    Eyebrow("Diagnosis")
                    Text(title).font(.title3.weight(.bold))
                    Text(text)
                    Callout(train, title: "Train", color: Color(hex: 0x0F6E56))
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
            default:
                if let node = nodes[step] {
                    VStack(alignment: .leading, spacing: 12) {
                        Eyebrow(label(for: step))
                        if let note = node.note {
                            Text(note).font(.subheadline).foregroundStyle(.secondary)
                        }
                        Text(node.question).font(.title3.weight(.semibold))
                        HStack(spacing: 10) {
                            Button { answer(node.yes) } label: { Text("Yes").frame(maxWidth: .infinity) }
                                .buttonStyle(.borderedProminent)
                            Button { answer(node.no) } label: { Text("No").frame(maxWidth: .infinity) }
                                .buttonStyle(.bordered)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                }
            }

            HStack {
                Button {
                    withAnimation { if let prev = history.popLast() { step = prev } }
                } label: { Label("Back", systemImage: "arrow.uturn.backward") }
                .disabled(history.isEmpty)
                Spacer()
                Button {
                    withAnimation { history = []; step = .q1 }
                } label: { Label("Start over", systemImage: "arrow.counterclockwise") }
                .disabled(history.isEmpty)
            }
            .font(.subheadline)

            Callout("Every lifting edge traces back to one of the four causes: prep, stretch, heat, or slip. Ask the questions in order, find which one broke, and fix that, not the symptom.", title: "The film didn't fail. The bond did.")
        }
    }

    private func label(for s: Step) -> String {
        switch s {
        case .q1: return "Q1 of 6"
        case .q2: return "Q2 of 6"
        case .q3: return "Q3 of 6"
        case .q4: return "Q4 of 6"
        case .q5: return "Q5 of 6"
        case .q6: return "Q6 of 6"
        case .result: return "Diagnosis"
        }
    }

    private func answer(_ o: Outcome) {
        withAnimation {
            history.append(step)
            switch o {
            case .go(let s): step = s
            case .verdict(let t, let x, let tr): step = .result(t, x, tr)
            }
        }
    }

    private var fourCauses: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Before you start: the four causes").font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                cause("Stretch", "Film stretched past its memory limit, pulling itself back.", Color(hex: 0xBA7517))
                cause("Surface prep", "Contamination preventing molecular (Van der Waals) contact.", Color(hex: 0x993C1D))
                cause("Activation", "No post-heat, so the adhesive never fully bonded on stretched or tight zones.", Color(hex: 0xA32D2D))
                cause("Slip & technique", "Wrong solution mix, trapped slip, or insufficient squeegee pressure.", Color(hex: 0x185FA5))
            }
        }
    }

    private func cause(_ title: String, _ text: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.subheadline.weight(.bold)).foregroundStyle(color)
            Text(text).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        .padding(10)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
    }

    // MARK: Reference tables

    private let symptoms: [(String, String)] = [
        ("Edge lifts within hours on a stretched curve", "Over-stretch with no heat set. First action: re-lift, relax, post-heat."),
        ("Edge lifts after a few days on a flat or low-stretch area", "Surface contamination (polish or oil residue). First action: remove, IPA degrease, reinstall."),
        ("Lifting around relief cuts or tight corners", "No post-heat activation. First action: apply heat with proper pressure."),
        ("Lifting with visible cloudiness underneath", "Trapped slip solution. First action: re-squeegee it out or replace the section."),
        ("Lifting only on bumper corners and mirror tips", "Combination: stretch plus missing post-heat. First action: re-position with less stretch, then post-heat."),
        ("Edge peels back when touched, no wrinkling", "Bond never formed (prep failure). First action: remove and start over with a proper degrease.")
    ]

    private let order: [(String, String)] = [
        ("When?", "Did it lift immediately or days later? That tells you stretch versus prep."),
        ("Where?", "Curved or stretched area, or flat panel? That tells you stretch versus surface."),
        ("What did you do last?", "Final wipe? Post-heat? That narrows it to activation or prep."),
        ("What's underneath?", "Cloudy means trapped slip. A clean lift means the bond never formed.")
    ]

    private var reference: some View {
        VStack(alignment: .leading, spacing: 18) {
            fourCauses

            VStack(alignment: .leading, spacing: 8) {
                Text("Quick reference: symptom to likely cause").font(.headline)
                ForEach(symptoms.indices, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(symptoms[i].0).font(.subheadline.weight(.semibold))
                        Text(symptoms[i].1).font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10))
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Train your installers to ask in this order").font(.headline)
                ForEach(order.indices, id: \.self) { i in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(i + 1)")
                            .font(.caption.weight(.bold))
                            .frame(width: 24, height: 24)
                            .background(Theme.accent, in: Circle())
                            .foregroundStyle(.white)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(order[i].0).font(.subheadline.weight(.semibold))
                            Text(order[i].1).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Callout("Every lifting edge traces back to one of the four causes: prep, stretch, heat, or slip. Ask the four questions in order, find which one broke, and fix that, not the symptom.", title: "The film didn't fail. The bond did.")

            DisclaimerFooter(text: "This is chapter 2.9 of the simonsays.coach PPF Installation Handbook, free in full. The handbook covers the other chapters: materials, adhesion, the full install workflow, and the business side.")
        }
    }
}

#Preview {
    NavigationStack { LiftingEdgesView() }
}
