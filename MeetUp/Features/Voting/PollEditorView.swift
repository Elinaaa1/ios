// MARK: - TWORZENIE ANKIETY
// Formularz pytania, typu i odpowiedzi oraz walidacja.

import SwiftUI


// MODEL POMOCNICZY OPCJI ODPOWIEDZI
struct PollDraftOption: Identifiable {
    let id = UUID()
    var title: String = ""
}

// TWORZENIE NOWEJ ANKIETY
struct PollEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss

    let meetingID: UUID
    @State private var question = ""
    @State private var kind: PollKind = .date
    
    @State private var draftOptions: [PollDraftOption] = [
        PollDraftOption(),
        PollDraftOption()
    ]

    // MARK: - ODCZYT I OCZYSZCZENIE PODANYCH ODPOWIEDZI
    private var enteredOptions: [String] {
        draftOptions
            .map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // MARK: - WALIDACJA: PYTANIE, MINIMUM 2 ROZNE ODPOWIEDZI
    private var canSave: Bool {
        let validQuestion = !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        let minimumOptions = enteredOptions.count >= 2
        
        let allOptionsFilled = enteredOptions.count == draftOptions.count
        
        let uniqueOptions = Set(enteredOptions.map { $0.lowercased() }).count
        
        return validQuestion && minimumOptions && allOptionsFilled && uniqueOptions
        
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Poll") {
                    TextField("Question, e.g. Where should we go?", text: $question)
                    Picker("Type", selection: $kind) {
                        ForEach(PollKind.allCases) { pollKind in
                            Text(pollKind.rawValue).tag(pollKind)
                        }
                    }
                }

                Section{
                    ForEach($draftOptions) { $option in
                        
                        HStack(spacing: 12) {
                            TextField("Enter an option", text: $option.title)
                            
                            Button(role: .destructive) {
                                removeOption(id: option.id)
                            } label: {
                                Image(systemName: "minus.circle.fill").foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                            .disabled(draftOptions.count <= 2)
                        }
                    }
                     
                    Button {addOption()} label: {
                        Label("Add option", systemImage: "plus.circle.fill").foregroundStyle(AppTheme.pink)
                    }
                } header: {
                    Text("Answer options")
                } footer: {
                    Text("Add at least two different answers. " + "You can add or remove more options.")
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
    
    private func addOption() {
        draftOptions.append(PollDraftOption())
    }
    
    private func removeOption(id: UUID) {
        guard draftOptions.count > 2 else {return}
        
        draftOptions.removeAll { $0.id == id }
    }

    // MARK: - UTWORZENIE ANKIETY I PRZYPISANIE JEJ DO SPOTKANIA
    private func createPoll() {
        guard canSave,
              var meeting = store.meetings.first(where: { $0.id == meetingID }) else { return }
        
        let pollOptions = enteredOptions.map(PollOption(title: $0))
        
        let newPoll = MeetingPoll(question: question.trimmingCharacters(in: .whitespacesAndNewlines), kind: kind, options: pollOptions)
        
        meeting.polls.append(newPoll)
        store.update(meeting)
        dismiss()
    }
}
