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
                    // MARK: - ROZOWO-TURKUSOWY NAGLOWEK WYDARZENIA
                    Section {
                        HStack {
                            Image(systemName: meeting.category.symbol).font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(meeting.title).font(.title2.bold())
                                Text(meeting.status.rawValue).font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding(12).foregroundStyle(AppTheme.textPrimary)
                        .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 18))
                    }
                    // MARK: - DANE PODSTAWOWE WYDARZENIA
                    Section("Details") {
                        Label(meeting.category.rawValue, systemImage: meeting.category.symbol)
                        Label(meeting.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        // MARK: - NOWY STATUS I PRZYPOMNIENIE
                        Label(meeting.status.rawValue, systemImage: meeting.status.symbol)
                        if meeting.reminder != .none {
                            Label(meeting.reminder.title, systemImage: "bell")
                        }
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
                            store.update(TaskService.deleting(at: offsets, from: meeting))
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
                        LabeledContent("Total", value: ExpenseCalculator.total(for: meeting)
                            .formatted(.currency(code: "PLN")))
                        LabeledContent("Per person (including you)", value:
                            ExpenseCalculator.share(for: meeting)
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
                .scrollContentBackground(.hidden)
                .background(AppTheme.background.ignoresSafeArea())
                .listRowBackground(Color.white)
                .navigationTitle(meeting.title)
                .tint(AppTheme.pink)
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

    // MARK: - PRZEKAZANIE OPERACJI NA ZADANIACH DO TASKSERVICE
    private func addTask() {
        guard let meeting, let updated = TaskService.adding(newTask, to: meeting) else { return }
        store.update(updated)
        newTask = ""
    }

    private func toggleTask(_ id: UUID) {
        guard let meeting else { return }
        store.update(TaskService.toggling(id, in: meeting))
    }
}
