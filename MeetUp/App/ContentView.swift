import SwiftUI

// MARK: - GLOWNA NAWIGACJA (5 MODULOW)
// Wszystkie widoki otrzymuja kolor akcentu z DesignSystem.
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            EventsView().tabItem { Label("Events", systemImage: "heart.text.square.fill") }
            CalendarView().tabItem { Label("Calendar", systemImage: "calendar") }
            FriendsView().tabItem { Label("Friends", systemImage: "person.2.fill") }
            ProfileView().tabItem { Label("Profile", systemImage: "sparkles") }
        }
        .tint(AppTheme.pink)
    }
}
