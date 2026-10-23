import SwiftUI

struct EventEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss

    var existing: Meeting? = nil
    @State private var title = ""
    @State private var date = Date().addingTimeInterval(3600)
    @State private var location = ""
    @State private var details = ""
    @State private var category: MeetingCategory = .social
    @State private var selectedFriends: Set<String> = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Event details") {
                    TextField("Name", text: $title)
                    DatePicker("Date and time", selection: $date)
                    TextField("Location", text: $location)
                    Picker("Category", selection: $category) {
                        ForEach(MeetingCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("Description", text: $details, axis: .vertical)
                        .lineLimit(2...5)
                }
                Section("Participants (local list)") {
                    if store.friends.isEmpty {
                        Text("Add friends in the Friends tab first.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(store.friends, id: \.self) { friend in
                        Button {
                            if selectedFriends.contains(friend) { selectedFriends.remove(friend) }
                            else { selectedFriends.insert(friend) }
                        } label: {
                            HStack {
                                Text(friend).foregroundStyle(.primary)
                                Spacer()
                                if selectedFriends.contains(friend) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.indigo)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(existing == nil ? "New Event" : "Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEvent() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                guard let existing else { return }
                title = existing.title
                date = existing.date
                location = existing.location
                details = existing.details
                category = existing.category
                selectedFriends = Set(existing.participantNames)
            }
        }
    }

    private func saveEvent() {
        var meeting = existing ?? Meeting(title: title, date: date, location: location, details: details, category: category)
        meeting.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        meeting.date = date
        meeting.location = location
        meeting.details = details
        meeting.category = category
        meeting.participantNames = selectedFriends.sorted()
        if existing == nil { store.add(meeting) }
        else { store.update(meeting) }
        dismiss()
    }
}
