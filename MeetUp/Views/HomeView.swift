import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: EventStore
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Plan something together!")
                        .font(.title2.bold())
                    Text("Upcoming meetings")
                        .font(.headline)
                    if store.upcomingMeetings.isEmpty {
                        ContentUnavailableView("No upcoming meetings", systemImage: "calendar.badge.plus", description: Text("Create your first event using the + button."))
                    } else {
                        ForEach(store.upcomingMeetings.prefix(5)) { meeting in
                            NavigationLink(value: meeting.id) {
                                EventCard(meeting: meeting)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MeetUp")
            .toolbar {
                Button { showingCreate = true } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Create event")
            }
            .navigationDestination(for: UUID.self) { id in EventDetailView(meetingID: id) }
            .sheet(isPresented: $showingCreate) { EventEditorView() }
        }
    }
}
