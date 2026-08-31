import SwiftUI

@main
struct SimonSaysApp: App {
    @AppStorage("appearanceMode") private var appearanceMode = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Theme.accent)
                .preferredColorScheme(
                    appearanceMode == "light" ? .light :
                    appearanceMode == "dark" ? .dark : nil
                )
        }
    }
}
