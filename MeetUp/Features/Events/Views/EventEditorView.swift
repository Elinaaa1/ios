import SwiftUI

// MARK: - FORMULARZ WYDARZENIA; LOGIKA W EVENTEDITORVIEWMODEL
struct EventEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = EventEditorViewModel()
    var existing: Meeting? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Event details") {
                    TextField("Name", text: $model.title)
                    DatePicker("Date and time", selection: $model.date)
                    TextField("Location", text: $model.location)
                    Picker("Category", selection: $model.category) {
                        ForEach(MeetingCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    TextField("Description", text: $model.details, axis: .vertical).lineLimit(2...5)
                }
                Section("Event status") {
                    Picker("Status", selection: $model.status) {
                        ForEach(EventStatus.allCases) { status in Text(status.rawValue).tag(status) }
                    }
                }
                ReminderSettingsView(selectedReminder: $model.reminder)
                Section("Participants") {
                    if store.friends.isEmpty {
                        Text("Add friends in the Friends tab first.").foregroundStyle(.secondary)
                    }
                    ForEach(store.friends, id: \.self) { friend in
                        Button { model.selectedFriends.formSymmetricDifference([friend]) } label: {
                            HStack {
                                Text(friend).foregroundStyle(AppTheme.textPrimary)
                                Spacer()
                                if model.selectedFriends.contains(friend) {
                                    Image(systemName: "checkmark.circle.fill").foregroundStyle(AppTheme.turquoise)
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .tint(AppTheme.pink)
            .navigationTitle(existing == nil ? "New Event" : "Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let meeting = model.makeMeeting(existing: existing) else { return }
                        if existing == nil { store.add(meeting) } else { store.update(meeting) }
                        dismiss()
                    }.disabled(!model.canSave)
                }
            }
            .onAppear { if let existing { model.load(existing) } }
        }
    }
}
