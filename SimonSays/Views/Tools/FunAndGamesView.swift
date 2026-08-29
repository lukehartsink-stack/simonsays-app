import SwiftUI

struct GameTool: Identifiable {
    let kind: String
    let title: String
    let text: String
    let path: String
    let icon: String
    var id: String { path }
    var url: URL { URL(string: "https://simonsays.coach/training-tools/fun-and-games/\(path)/")! }
}

/// The nine browser-based drills, demos and games. They're interactive HTML tools on simonsays.coach,
/// so they open inside the app in a web view.
struct FunAndGamesView: View {
    private let tools: [GameTool] = [
        .init(kind: "Productivity", title: "Daily Drill Draw",
              text: "Random hands-on drills for the start of a training day. Editable deck, printable cards.",
              path: "daily-drill-draw", icon: "rectangle.stack.fill"),
        .init(kind: "Productivity", title: "Pre-flight Checklist",
              text: "A randomised pre-install check — mandatory items every time, optional items rotated in to keep your eyes on the page.",
              path: "pre-flight-checklist", icon: "checklist"),
        .init(kind: "Visualisation", title: "Stretch Lab",
              text: "Drag the corners of a film panel and watch the grid distort. Live readouts of area stretch, edge stretch and film thickness.",
              path: "stretch-lab", icon: "arrow.up.left.and.arrow.down.right"),
        .init(kind: "Visualisation", title: "Heat & Tack Lab",
              text: "Two-axis view of the climate you install in. Drag the marker through temperature and humidity combinations; a live dew point readout tells you when panels will sweat.",
              path: "heat-tack-lab", icon: "thermometer.sun.fill"),
        .init(kind: "Visualisation · Customer-facing", title: "Self-heal Demo",
              text: "Side-by-side panels — plain paint on one, PPF on the other. Scratch both, then run a heat lamp over the PPF panel and watch the scratches fade.",
              path: "self-heal-demo", icon: "wand.and.stars"),
        .init(kind: "Game · Eye drill", title: "Spot the Defect",
              text: "Bubbles, lifts and dirt specks appear on a panel. Tap them before each one's ring runs out. Sixty-second eye-training warm-up for QC.",
              path: "spot-the-defect", icon: "eye.fill"),
        .init(kind: "Game · Diagnosis", title: "Defect Diagnoser",
              text: "See a defect on a panel, pick the most likely root cause from four options. Ten rounds, with explanations after each answer.",
              path: "defect-diagnoser", icon: "stethoscope"),
        .init(kind: "Game · Planning", title: "Panel Sequence Puzzle",
              text: "Ten panels scrambled — drag them into the correct install order. Timed, scored, and the canonical sequence is editable.",
              path: "panel-sequence-puzzle", icon: "square.grid.3x2.fill"),
        .init(kind: "Self-test", title: "PPF Knowledge Quiz",
              text: "Twenty randomised multiple-choice questions across Materials, Application, Defects and Business. Per-category breakdown at the end.",
              path: "ppf-knowledge-quiz", icon: "graduationcap.fill")
    ]

    var body: some View {
        List {
            Section {
                Text("Nine interactive tools for PPF installers and detailers — drills, demos, quizzes and games. Use them as class warm-ups, customer-facing demos, or quiet self-tests at the end of a long day.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section {
                ForEach(tools) { t in
                    NavCard(badge: t.kind, title: t.title, text: t.text, systemImage: t.icon) {
                        WebPage(title: t.title, url: t.url)
                    }
                }
            } footer: {
                Text("These tools run in the browser on simonsays.coach and need an internet connection.")
            }
        }
        .navigationTitle("Fun & Games")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { FunAndGamesView() }
}
