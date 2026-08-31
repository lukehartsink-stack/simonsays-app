import SwiftUI

/// The Profile tab: your profile, dashboard, appearance, and everything from the old More tab.
struct ProfileView: View {
    @ObservedObject private var store = ProfileStore.shared
    @ObservedObject private var appState = AppState.shared
    @AppStorage("appearanceMode") private var appearanceMode = "system"
    @AppStorage("recentSearches") private var recentData = Data()
    @State private var editing = false

    private var recents: [String] {
        (try? JSONDecoder().decode([String].self, from: recentData)) ?? []
    }

    var body: some View {
        NavigationStack {
            List {
                if let profile = store.profile {
                    header(profile)
                    dashboard
                } else {
                    ProfileSetupSection()
                }

                Section("Appearance") {
                    Picker(selection: $appearanceMode) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    } label: {
                        Label("Theme", systemImage: appearanceMode == "dark" ? "moon.fill" : "sun.max.fill")
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    LibraryRow(title: "About Simon", subtitle: "Founder and trainer · the independence note", icon: "person.crop.circle.fill", color: Theme.accent) { AboutView() }
                    LibraryRow(title: "The Handbook", subtitle: "Editions and how to get it", icon: "book.closed.fill", color: Theme.accentDeep) { HandbookContentView() }
                    LibraryRow(title: "PPF Quote Calculator", subtitle: "Excel quoting tool · Profilm edition", icon: "tablecells.fill", color: SearchKind.tool.color) { QuoteCalculatorView() }
                }

                Section("Contact") {
                    Link(destination: URL(string: "mailto:\(Theme.contactEmail)")!) {
                        Label(Theme.contactEmail, systemImage: "envelope.fill")
                    }
                    Link(destination: URL(string: "https://www.instagram.com/simoncrookes_ppf/")!) {
                        Label("Instagram @simoncrookes_ppf", systemImage: "camera.fill")
                    }
                    Link(destination: Theme.siteURL) {
                        Label("simonsays.coach", systemImage: "safari.fill")
                    }
                }

                Section {
                    Link("Legal notice", destination: URL(string: "https://simonsays.coach/legal/")!)
                    Link("Privacy", destination: URL(string: "https://simonsays.coach/privacy/")!)
                } footer: {
                    Text("Independent training and support for PPF installers and car detailers. Content and media partnership with Charlie Detailing.\n\nVersion \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"))")
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $editing) {
                ProfileEditSheet()
            }
        }
    }

    // MARK: Header

    private func header(_ profile: UserProfile) -> some View {
        Section {
            HStack(spacing: 14) {
                Text(profile.initials.isEmpty ? "?" : profile.initials)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(Theme.accent, in: Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(profile.name).font(.title3.weight(.semibold))
                    HStack(spacing: 6) {
                        Image(systemName: profile.role.icon).font(.caption)
                        Text(profile.role.label)
                        if !profile.shopName.isEmpty {
                            Text("· \(profile.shopName)")
                        }
                    }
                    .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Button("Edit") { editing = true }
                    .font(.subheadline)
            }
            .padding(.vertical, 6)
        }
    }

    // MARK: Dashboard

    private var dashboard: some View {
        Section("Your dashboard") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                MetricCard(label: "Tests taken", value: "\(store.testsTaken)", sub: store.testsTaken > 0 ? "avg \(store.averagePct)%" : nil)
                MetricCard(label: "Best score", value: store.testsTaken > 0 ? "\(store.bestPct)%" : "—")
                MetricCard(label: "Saved answers", value: "\(store.bookmarkedFAQs.count)")
            }
            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            .listRowBackground(Color.clear)

            NavigationLink {
                SavedAnswersView()
            } label: {
                Label("Saved answers", systemImage: "bookmark.fill")
            }

            Button {
                appState.selectedTab = 2
            } label: {
                Label("Your tests & progress", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.primary)
            }

            if !recents.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Previous questions").font(.subheadline.weight(.semibold))
                    FlowLayout(spacing: 8) {
                        ForEach(recents.prefix(6), id: \.self) { r in
                            Button {
                                appState.openSearch(r)
                            } label: {
                                Text(r)
                                    .font(.caption)
                                    .padding(.horizontal, 10).padding(.vertical, 6)
                                    .background(Theme.tint, in: Capsule())
                                    .overlay(Capsule().stroke(Theme.tintBorder))
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Saved answers

struct SavedAnswersView: View {
    @ObservedObject private var store = ProfileStore.shared

    var body: some View {
        List {
            if store.bookmarkedFAQs.isEmpty {
                ContentUnavailableView(
                    "No saved answers yet",
                    systemImage: "bookmark",
                    description: Text("Tap the bookmark on any FAQ answer to keep it here for quick access on the job.")
                )
            } else {
                ForEach(store.bookmarkedFAQs) { f in
                    NavigationLink {
                        FAQDetailView(item: f)
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(f.q).font(.body).lineLimit(2)
                            Text(f.a).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .navigationTitle("Saved Answers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Setup & edit

/// Shown on the Profile tab until a profile exists.
struct ProfileSetupSection: View {
    @State private var name = ""
    @State private var role: UserRole = .detailer
    @State private var shop = ""

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow("Your profile")
                Text("Set up your profile").font(.title3.weight(.bold))
                Text("Keep your test scores, saved answers, and progress in one place. Everything stays on this phone.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)

            TextField("Your name", text: $name)
                .textContentType(.name)
            Picker("I am a…", selection: $role) {
                ForEach(UserRole.allCases) { r in Text(r.label).tag(r) }
            }
            TextField("Shop or company (optional)", text: $shop)

            Button {
                ProfileStore.shared.profile = UserProfile(
                    name: name.trimmingCharacters(in: .whitespaces),
                    role: role,
                    shopName: shop.trimmingCharacters(in: .whitespaces)
                )
            } label: {
                Label("Create profile", systemImage: "person.crop.circle.badge.plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
    }
}

struct ProfileEditSheet: View {
    @ObservedObject private var store = ProfileStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var role: UserRole = .detailer
    @State private var shop = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Your name", text: $name)
                Picker("I am a…", selection: $role) {
                    ForEach(UserRole.allCases) { r in Text(r.label).tag(r) }
                }
                TextField("Shop or company (optional)", text: $shop)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.profile = UserProfile(
                            name: name.trimmingCharacters(in: .whitespaces),
                            role: role,
                            shopName: shop.trimmingCharacters(in: .whitespaces)
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let p = store.profile {
                    name = p.name; role = p.role; shop = p.shopName
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
