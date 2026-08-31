import SwiftUI

struct ContentView: View {
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            SearchHomeView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(0)

            NavigationStack { HandbookContentView() }
                .tabItem { Label("Handbook", systemImage: "book.closed.fill") }
                .tag(1)

            TestsView()
                .tabItem { Label("Tests", systemImage: "checkmark.circle.fill") }
                .tag(2)

            LibraryView()
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
}
