// MARK: - TWORZENIE ANKIETY
// Formularz pytania, typu i odpowiedzi oraz walidacja.

import SwiftUI

struct PollEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss

    let meetingID: UUID
    @State private var question = ""
    @State private var kind: PollKind = .date
    @State private var optionOne = ""
    @State private var optionTwo = ""
    @State private var optionThree = ""

    // MARK: - ODCZYT I OCZYSZCZENIE PODANYCH ODPOWIEDZI
    private var enteredOptions: [String] {
        [optionOne, optionTwo, optionThree]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // MARK: - WALIDACJA: PYTANIE, MINIMUM 2 ROZNE ODPOWIEDZI
    private var canSave: Bool {
        !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        enteredOptions.count >= 2 &&
        Set(enteredOptions.map { $0.lowercased() }).count == enteredOptions.count
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Poll") {
                    TextField("Question, e.g. Where should we go?", text: $question)
                    Picker("Type", selection: $kind) {
                        ForEach(PollKind.allCases) { kind in
                            Text(kind.rawValue).tag(kind)
                        }
                    }
                }

                Section("Choices (at least two)") {
                    TextField("First option", text: $optionOne)
                    TextField("Second option", text: $optionTwo)
                    TextField("Third option (optional)", text: $optionThree)
                }

                Section {
                    Text("Votes are stored locally. Friends are selected by name on this device.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("New poll")
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppTheme.pink)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createPoll() }
                        .disabled(!canSave)
                }
            }
        }
    }

    // MARK: - UTWORZENIE ANKIETY I PRZYPISANIE JEJ DO SPOTKANIA
    private func createPoll() {
        guard canSave,
              var meeting = store.meetings.first(where: { $0.id == meetingID }) else { return }
        meeting.polls.append(MeetingPoll(
            question: question.trimmingCharacters(in: .whitespacesAndNewlines),
            kind: kind,
            options: enteredOptions.map { PollOption(title: $0) }
        ))
        store.update(meeting)
        dismiss()
    }
}
