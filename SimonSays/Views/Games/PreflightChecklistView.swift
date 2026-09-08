import SwiftUI

/// A working pre-install check, randomised so it stays a check and not a habit.
struct PreflightChecklistView: View {
    private static let optionalCount = 5

    @State private var date = Date()
    @State private var vehicle = ""
    @State private var installer = ""
    @State private var items: [GameData.ChecklistItem] = []
    @State private var checked: Set<String> = []

    private var grouped: [(category: String, items: [GameData.ChecklistItem])] {
        GameData.checklistCategories.compactMap { (c: String) -> (category: String, items: [GameData.ChecklistItem])? in
            let g = items.filter { $0.category == c }
            return g.isEmpty ? nil : (c, g)
        }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow("Productivity")
                    Text("Mandatory items appear every time you generate the list. Optional items rotate in randomly, so the page is never quite identical twice — your eyes stay on each line instead of running on memory.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }

            Section("Job") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Vehicle", text: $vehicle)
                TextField("Installer", text: $installer)
            }

            Section {
                Button {
                    generate()
                } label: {
                    Label("Generate new checklist", systemImage: "arrow.clockwise").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            ForEach(grouped, id: \.category) { group in
                Section(group.category) {
                    ForEach(group.items) { item in
                        Button {
                            if checked.contains(item.id) { checked.remove(item.id) } else { checked.insert(item.id) }
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: checked.contains(item.id) ? "checkmark.square.fill" : "square")
                                    .font(.title3)
                                    .foregroundStyle(checked.contains(item.id) ? Theme.accent : Theme.muted)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.text)
                                        .strikethrough(checked.contains(item.id), color: Theme.muted)
                                        .foregroundStyle(.primary)
                                    if item.mandatory {
                                        Text("MANDATORY").font(.caption2.weight(.semibold)).tracking(0.6).foregroundStyle(Theme.accent)
                                    }
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if !items.isEmpty {
                Section {
                    HStack {
                        Text("\(checked.count) of \(items.count) ticked").font(.subheadline).foregroundStyle(.secondary)
                        Spacer()
                        ShareLink(item: shareText) { Label("Share", systemImage: "square.and.arrow.up") }
                    }
                } footer: {
                    Text("How this works: the items marked mandatory are on every list — those are the ones you can't skip without consequences. The optional items rotate in randomly so the list stays unfamiliar enough to read.")
                }
            }
        }
        .navigationTitle("Pre-flight Checklist")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if items.isEmpty { generate() } }
    }

    private func generate() {
        let bank = GameData.checklist
        let mandatory = bank.filter(\.mandatory)
        let optional = bank.filter { !$0.mandatory }.shuffled().prefix(Self.optionalCount)
        items = (mandatory + optional).shuffled()
        checked = []
    }

    private var shareText: String {
        var s = "Pre-flight checklist — simonsays.coach\n"
        s += "Date: \(date.formatted(date: .abbreviated, time: .omitted))"
        if !vehicle.isEmpty { s += " · Vehicle: \(vehicle)" }
        if !installer.isEmpty { s += " · Installer: \(installer)" }
        s += "\n\n"
        for g in grouped {
            s += "\(g.category)\n"
            for i in g.items { s += (checked.contains(i.id) ? "[x] " : "[ ] ") + i.text + (i.mandatory ? " (mandatory)" : "") + "\n" }
            s += "\n"
        }
        return s
    }
}

#Preview {
    NavigationStack { PreflightChecklistView() }
}
