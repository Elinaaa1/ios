import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    let meetingID: UUID
    @State private var showingEdit = false
    @State private var newTask = ""

    private var meeting: Meeting? { store.meetings.first { $0.id == meetingID } }

    var body: some View {
        Group {
            if let meeting {
                List {
                    Section("Details") {
                        Label(meeting.category.rawValue, systemImage: meeting.category.symbol)
                        Label(meeting.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        if !meeting.location.isEmpty { Label(meeting.location, systemImage: "mappin") }
                        if !meeting.details.isEmpty { Text(meeting.details) }
                    }
                    Section("Participants") {
                        if meeting.participantNames.isEmpty { Text("No participants selected").foregroundStyle(.secondary) }
                        ForEach(meeting.participantNames, id: \.self) { name in Label(name, systemImage: "person") }
                    }
                    Section("Preparation checklist") {
                        ForEach(meeting.tasks) { task in
                            Button { toggleTask(task.id) } label: {
                                Label(task.title, systemImage: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isDone ? .secondary : .primary)
                            }
                        }
                        .onDelete { offsets in
                            var updated = meeting
                            updated.tasks.remove(atOffsets: offsets)
                            store.update(updated)
                        }
                        HStack {
                            TextField("New task", text: $newTask)
                            Button { addTask() } label: { Image(systemName: "plus.circle.fill") }
                                .disabled(newTask.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    Section {
                        Button("Delete event", role: .destructive) {
                            store.delete(meetingID)
                            dismiss()
                        }
                    }
                }
                .navigationTitle(meeting.title)
                .toolbar { Button("Edit") { showingEdit = true } }
                .sheet(isPresented: $showingEdit) { EventEditorView(existing: meeting) }
            } else {
                ContentUnavailableView("Event not found", systemImage: "calendar.badge.exclamationmark")
            }
        }
    }

    private func addTask() {
        guard var updated = meeting else { return }
        let clean = newTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        updated.tasks.append(MeetingTask(title: clean))
        store.update(updated)
        newTask = ""
    }

    private func toggleTask(_ id: UUID) {
        guard var updated = meeting, let index = updated.tasks.firstIndex(where: { $0.id == id }) else { return }
        updated.tasks[index].isDone.toggle()
        store.update(updated)
    }
}
