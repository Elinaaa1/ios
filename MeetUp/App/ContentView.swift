import SwiftUI

// MARK: - GLOWNA NAWIGACJA
// Nowa zakladka Calendar. Pozostale funkcje pozostaja bez zmian.
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            EventsView()
                .tabItem { Label("Events", systemImage: "list.bullet.rectangle") }
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
            FriendsView()
                .tabItem { Label("Friends", systemImage: "person.2") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(AppTheme.pink)
    }
}
