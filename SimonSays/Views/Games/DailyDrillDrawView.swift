import SwiftUI

/// Three random hands-on drills to start the training day.
struct DailyDrillDrawView: View {
    @State private var picks: [GameData.Drill] = []
    @State private var drawnOn: Date? = nil

    private var deck: [GameData.Drill] { GameData.drills }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Eyebrow("Productivity")
                Text("Daily Drill Draw").font(.largeTitle.weight(.bold))
                Text("Three random hands-on drills to start the training day. Draw again for a fresh set.")
                    .font(.body).foregroundStyle(.secondary)

                HStack {
                    Button {
                        withAnimation { picks = Array(deck.shuffled().prefix(3)); drawnOn = Date() }
                    } label: {
                        Label("Draw 3 drills", systemImage: "shuffle").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(deck.count < 3)

                    if !picks.isEmpty {
                        ShareLink(item: shareText) {
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.bordered)
                    }
                }

                if picks.isEmpty {
                    Text("Tap \"Draw 3 drills\" to start.").font(.subheadline).foregroundStyle(.secondary)
                } else {
                    ForEach(picks) { d in card(d) }
                    if let drawnOn {
                        Text("Drawn \(drawnOn.formatted(date: .abbreviated, time: .omitted)) from a deck of \(deck.count).")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Daily Drill Draw")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func card(_ d: GameData.Drill) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(d.title).font(.headline)
            HStack(spacing: 8) {
                Pill(text: d.difficulty, color: color(for: d.difficulty))
                Text("~\(d.minutes) min").font(.caption).foregroundStyle(.secondary)
            }
            Text(d.desc).font(.subheadline).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func color(for difficulty: String) -> Color {
        switch difficulty {
        case "Beginner": return Theme.iconBlue
        case "Intermediate": return Theme.iconDeep
        default: return Theme.iconSlate
        }
    }

    private var shareText: String {
        var s = "Today's drills — simonsays.coach\n\n"
        for d in picks {
            s += "• \(d.title) (\(d.difficulty), ~\(d.minutes) min)\n  \(d.desc)\n\n"
        }
        return s
    }
}

#Preview {
    NavigationStack { DailyDrillDrawView() }
}
