import SwiftUI

/// The nine drills, demos, quizzes and games, all native. Content banks come from
/// simonsays.coach via `tools/sync-content.js`; the interactive labs are ported to SwiftUI.
struct FunAndGamesView: View {
    enum Tool: String, CaseIterable, Identifiable {
        case drillDraw, checklist, stretchLab, heatTackLab, selfHeal, spotDefect, diagnoser, panelPuzzle, quiz
        var id: String { rawValue }

        var kind: String {
            switch self {
            case .drillDraw, .checklist: return "Productivity"
            case .stretchLab, .heatTackLab: return "Visualisation"
            case .selfHeal: return "Visualisation · Customer-facing"
            case .spotDefect: return "Game · Eye drill"
            case .diagnoser: return "Game · Diagnosis"
            case .panelPuzzle: return "Game · Planning"
            case .quiz: return "Self-test"
            }
        }
        var title: String {
            switch self {
            case .drillDraw: return "Daily Drill Draw"
            case .checklist: return "Pre-flight Checklist"
            case .stretchLab: return "Stretch Lab"
            case .heatTackLab: return "Heat & Tack Lab"
            case .selfHeal: return "Self-heal Demo"
            case .spotDefect: return "Spot the Defect"
            case .diagnoser: return "Defect Diagnoser"
            case .panelPuzzle: return "Panel Sequence Puzzle"
            case .quiz: return "PPF Knowledge Quiz"
            }
        }
        var text: String {
            switch self {
            case .drillDraw: return "Random hands-on drills for the start of a training day. Three at a time, shareable."
            case .checklist: return "A randomised pre-install check — mandatory items every time, optional items rotated in to keep your eyes on the page."
            case .stretchLab: return "Drag the corners of a film panel and watch the grid distort. Live readouts of area stretch, edge stretch and film thickness."
            case .heatTackLab: return "Two-axis view of the climate you install in. Drag the marker through temperature and humidity combinations; a live dew point readout tells you when panels will sweat."
            case .selfHeal: return "Two panels — plain paint and PPF. Scratch both, then run a heat lamp over the PPF panel and watch the scratches fade."
            case .spotDefect: return "Bubbles, lifts and dirt specks appear on a panel. Tap them before each one's ring runs out. Sixty-second eye-training warm-up for QC."
            case .diagnoser: return "See a defect on a panel, pick the most likely root cause from four options. Ten rounds, with explanations after each answer."
            case .panelPuzzle: return "Panels scrambled — drag them into the correct install order. Timed, scored, best result kept."
            case .quiz: return "Twenty randomised multiple-choice questions across Materials, Application, Defects and Business. Per-category breakdown at the end."
            }
        }
        var icon: String {
            switch self {
            case .drillDraw: return "rectangle.stack.fill"
            case .checklist: return "checklist"
            case .stretchLab: return "arrow.up.left.and.arrow.down.right"
            case .heatTackLab: return "thermometer.sun.fill"
            case .selfHeal: return "wand.and.stars"
            case .spotDefect: return "eye.fill"
            case .diagnoser: return "stethoscope"
            case .panelPuzzle: return "square.grid.3x2.fill"
            case .quiz: return "graduationcap.fill"
            }
        }

        @ViewBuilder var destination: some View {
            switch self {
            case .drillDraw: DailyDrillDrawView()
            case .checklist: PreflightChecklistView()
            case .stretchLab: StretchLabView()
            case .heatTackLab: HeatTackLabView()
            case .selfHeal: SelfHealDemoView()
            case .spotDefect: SpotTheDefectView()
            case .diagnoser: DefectDiagnoserView()
            case .panelPuzzle: PanelSequencePuzzleView()
            case .quiz: KnowledgeQuizView()
            }
        }
    }

    var body: some View {
        List {
            Section {
                Text("Nine interactive tools for PPF installers and detailers — drills, demos, quizzes and games. Use them as class warm-ups, customer-facing demos, or quiet self-tests at the end of a long day.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section {
                ForEach(Tool.allCases) { t in
                    NavCard(badge: t.kind, title: t.title, text: t.text, systemImage: t.icon) {
                        t.destination
                    }
                }
            } footer: {
                Text("Everything here works offline.")
            }
        }
        .navigationTitle("Fun & Games")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { FunAndGamesView() }
}
