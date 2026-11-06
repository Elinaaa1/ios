// MARK: - START APLIKACJI
// Tworzy wspolny EventStore i przekazuje go do wszystkich ekranow.

import SwiftUI

@main
struct MeetUpApp: App {
    @StateObject private var store = EventStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
