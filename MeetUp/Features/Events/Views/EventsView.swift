// MARK: - LISTA WYDARZEN
// Wyszukiwanie, filtrowanie i otwieranie spotkan.

import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: EventStore
    @State private var showingCreate = false
    @State private var searchText = ""
    @State private var selectedCategory: String = "All"

    // MARK: - FILTROWANIE WYDZIELONE DO EVENTSFILTER
    private var filteredMeetings: [Meeting] {
        EventsFilter.apply(store.sortedMeetings, search: searchText, category: selectedCategory)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your plans, your vibe ✨").font(.title2.bold())
                        Text("Find every hangout in one place.").font(.subheadline)
                    }
                    .foregroundStyle(AppTheme.textPrimary)
                    .padding(10).frame(maxWidth: .infinity, alignment: .leading)
                    .listRowBackground(AppTheme.softGradient)
                }
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    ForEach(MeetingCategory.allCases) { category in
                        Text(category.rawValue).tag(category.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .listRowBackground(AppTheme.softGradient)
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
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .tint(AppTheme.pink)
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
