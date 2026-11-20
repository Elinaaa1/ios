import SwiftUI

// MARK: - WIDOK TWORZENIA ANKIETY
// Tylko wyswietlanie pol i przekazanie akcji do PollEditorViewModel.
struct PollEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = PollEditorViewModel()
    let meetingID: UUID

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("MAKE THE PLAN", systemImage: "sparkles")
                            .font(.caption.bold()).foregroundStyle(AppTheme.pink)
                        Text("Ask the group!").font(.largeTitle.bold()).foregroundStyle(AppTheme.textPrimary)
                        Text("Create as many choices as you need.").foregroundStyle(AppTheme.textSecondary)
                    }.padding(20).frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 24))

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Your question").font(.headline)
                        TextField("Where should we go?", text: $model.question)
                            .textFieldStyle(.roundedBorder)
                        Picker("Poll type", selection: $model.kind) {
                            ForEach(PollKind.allCases) { kind in Text(kind.rawValue).tag(kind) }
                        }
                    }.slayCard()

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Answer options").font(.headline)
                            Spacer()
                            Text("\(model.options.count) choices").font(.caption.bold()).foregroundStyle(AppTheme.turquoise)
                        }
                        ForEach($model.options) { $option in
                            HStack {
                                TextField("Enter an option", text: $option.title)
                                    .textFieldStyle(.roundedBorder)
                                Button {
                                    model.removeOption(id: option.id)
                                } label: {
                                    Image(systemName: "minus.circle.fill").foregroundStyle(AppTheme.pink)
                                }
                                .disabled(model.options.count <= 2)
                                .accessibilityLabel("Remove option")
                            }
                        }
                        Button { model.addOption() } label: {
                            Label("Add another option", systemImage: "plus.circle.fill")
                                .font(.headline).frame(maxWidth: .infinity).padding(12)
                                .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 14))
                        }
                        .foregroundStyle(AppTheme.textPrimary)
                        Text("At least two unique, non-empty answers are required.")
                            .font(.caption).foregroundStyle(AppTheme.textSecondary)
                    }.slayCard()
                }.padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("New poll")
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppTheme.pink)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { savePoll() }.disabled(!model.canSave)
                }
            }
        }
    }

    // MARK: - INTEGRACJA WIDOKU Z EVENTSTORE
    // Walidacja i konstrukcja ankiety sa juz w ViewModel.
    private func savePoll() {
        guard let poll = model.makePoll(),
              var meeting = store.meetings.first(where: { $0.id == meetingID }) else { return }
        meeting.polls.append(poll)
        store.update(meeting)
        dismiss()
    }
}
