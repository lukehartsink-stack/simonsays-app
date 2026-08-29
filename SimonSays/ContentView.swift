import SwiftUI

struct ContentView: View {
    @State private var selection: AppTab = .home

    var body: some View {
        TabView(selection: $selection) {
            HomeView(selectTab: { selection = $0 })
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)

            SupportView()
                .tabItem { Label("Support", systemImage: "lifepreserver.fill") }
                .tag(AppTab.support)

            HandbookView()
                .tabItem { Label("Handbook", systemImage: "book.closed.fill") }
                .tag(AppTab.handbook)

            ToolsView()
                .tabItem { Label("Tools", systemImage: "wrench.and.screwdriver.fill") }
                .tag(AppTab.tools)

            MoreView()
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }
                .tag(AppTab.more)
        }
    }
}

enum AppTab: Hashable {
    case home, support, handbook, tools, more
}

#Preview {
    ContentView()
}
