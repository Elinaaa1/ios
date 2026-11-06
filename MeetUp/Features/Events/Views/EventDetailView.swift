// MARK: - SZCZEGOLY SPOTKANIA
// Sekcje: informacje, uczestnicy, zadania, ankiety i wydatki.

import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    let meetingID: UUID
    @State private var showingEdit = false
    @State private var newTask = ""
    @State private var showingExpenseForm = false
    @State private var showingPollEditor = false

    private var meeting: Meeting? { store.meetings.first { $0.id == meetingID } }

    var body: some View {
        Group {
            if let meeting {
                List {
                    // MARK: - DANE PODSTAWOWE WYDARZENIA
                    Section("Details") {
                        Label(meeting.category.rawValue, systemImage: meeting.category.symbol)
                        Label(meeting.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        if !meeting.location.isEmpty { Label(meeting.location, systemImage: "mappin") }
                        if !meeting.details.isEmpty { Text(meeting.details) }
                    }
                    // MARK: - UCZESTNICY
                    Section("Participants") {
                        if meeting.participantNames.isEmpty { Text("No participants selected").foregroundStyle(.secondary) }
                        ForEach(meeting.participantNames, id: \.self) { name in Label(name, systemImage: "person") }
                    }
                    // MARK: - LISTA ZADAN
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
                    // MARK: - ANKIETY I PRZEJSCIE DO GLOSOWANIA
                    Section("Polls") {
                        if meeting.polls.isEmpty {
                            Text("No polls yet. Ask friends to pick a date or place!")
                                .foregroundStyle(.secondary)
                        }
                        ForEach(meeting.polls) { poll in
                            NavigationLink {
                                PollDetailView(meetingID: meetingID, pollID: poll.id)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(poll.question).font(.headline)
                                    Text("\(poll.kind.rawValue) • \(poll.votes.count) votes")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        Button {
                            showingPollEditor = true
                        } label: {
                            Label("Create poll", systemImage: "plus.circle.fill")
                                .foregroundStyle(AppTheme.pink)
                        }
                    }
                    // MARK: - WYDATKI I ICH PODZIAL
                    Section("Shared expenses") {
                        ForEach(meeting.expenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                    Text("Paid by: \(expense.paidBy)")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(expense.amount, format: .currency(code: "PLN"))
                            }
                        }
                        .onDelete { offsets in
                            var updated = meeting
                            updated.expenses.remove(atOffsets: offsets)
                            store.update(updated)
                        }
                        LabeledContent("Total", value: totalExpenses(for: meeting)
                            .formatted(.currency(code: "PLN")))
                        let peopleCount = meeting.participantNames.count + 1
                        LabeledContent("Per person (including you)", value:
                            (totalExpenses(for: meeting) / Double(peopleCount))
                            .formatted(.currency(code: "PLN")))
                        Button("Add expense", systemImage: "plus.circle") {
                            showingExpenseForm = true
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
                .sheet(isPresented: $showingPollEditor) {
                    PollEditorView(meetingID: meetingID)
                }
                .sheet(isPresented: $showingExpenseForm) {
                    ExpenseEditorView(meetingID: meetingID)
                }
            } else {
                ContentUnavailableView("Event not found", systemImage: "calendar.badge.exclamationmark")
            }
        }
    }

    // MARK: - SUMOWANIE WSZYSTKICH WYDATKOW PRZEZ REDUCE
    private func totalExpenses(for meeting: Meeting) -> Double {
        meeting.expenses.reduce(0) { sum, expense in
            sum + expense.amount
        }
    }

    // MARK: - DODAWANIE ZADANIA DO LISTY
    private func addTask() {
        guard var updated = meeting else { return }
        let clean = newTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        updated.tasks.append(MeetingTask(title: clean))
        store.update(updated)
        newTask = ""
    }

    // MARK: - ZMIANA STATUSU ZADANIA
    private func toggleTask(_ id: UUID) {
        guard var updated = meeting, let index = updated.tasks.firstIndex(where: { $0.id == id }) else { return }
        updated.tasks[index].isDone.toggle()
        store.update(updated)
    }
}
