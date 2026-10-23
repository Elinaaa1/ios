import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            EventsView()
                .tabItem { Label("Events", systemImage: "calendar") }
            FriendsView()
                .tabItem { Label("Friends", systemImage: "person.2") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(.indigo)
    }
}
