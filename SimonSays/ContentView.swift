import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchHomeView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            LibraryView()
                .tabItem { Label("Library", systemImage: "books.vertical.fill") }

            ToolsView()
                .tabItem { Label("Tools", systemImage: "wrench.and.screwdriver.fill") }

            MoreView()
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }
        }
    }
}

#Preview {
    ContentView()
}
