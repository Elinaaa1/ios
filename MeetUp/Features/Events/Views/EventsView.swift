// MARK: - LISTA WYDARZEN
// Wyszukiwanie, filtrowanie i otwieranie spotkan.

import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var showingCreate = false
    @State private var searchText = ""
    @State private var selectedCategory: String = "All"

    // MARK: - WYSZUKIWANIE I FILTROWANIE WYDARZEN
    private var filteredMeetings: [Meeting] {
        store.sortedMeetings.filter { meeting in
            let matchesSearch = searchText.isEmpty ||
                meeting.title.localizedCaseInsensitiveContains(searchText) ||
                meeting.location.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "All" ||
                meeting.category.rawValue == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    ForEach(MeetingCategory.allCases) { category in
                        Text(category.rawValue).tag(category.rawValue)
                    }
                }
                .pickerStyle(.menu)
                if filteredMeetings.isEmpty {
                    ContentUnavailableView("No events yet", systemImage: "calendar", description: Text("Tap + to add a meeting."))
                } else {
                    ForEach(filteredMeetings) { meeting in
                        NavigationLink(value: meeting.id) {
                            EventCard(meeting: meeting)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete { offsets in
                        let items = filteredMeetings
                        for index in offsets { store.delete(items[index].id) }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search events or locations")
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
