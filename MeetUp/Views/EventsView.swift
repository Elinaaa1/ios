import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var showingCreate = false

    var body: some View {
        NavigationStack {
            List {
                if store.sortedMeetings.isEmpty {
                    ContentUnavailableView("No events yet", systemImage: "calendar", description: Text("Tap + to add a meeting."))
                } else {
                    ForEach(store.sortedMeetings) { meeting in
                        NavigationLink(value: meeting.id) {
                            EventCard(meeting: meeting)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete { offsets in
                        let items = store.sortedMeetings
                        for index in offsets { store.delete(items[index].id) }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Events")
            .toolbar {
                Button { showingCreate = true } label: { Image(systemName: "plus") }
                    .accessibilityLabel("Create event")
            }
            .navigationDestination(for: UUID.self) { id in EventDetailView(meetingID: id) }
            .sheet(isPresented: $showingCreate) { EventEditorView() }
        }
    }
}
