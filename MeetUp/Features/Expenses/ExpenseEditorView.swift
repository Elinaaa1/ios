import SwiftUI

// MARK: - WIDOK DODAWANIA WYDATKU
struct ExpenseEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model = ExpenseEditorViewModel()
    let meetingID: UUID
    private var meeting: Meeting? { store.meetings.first { $0.id == meetingID } }

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense details") {
                    TextField("What was purchased?", text: $model.title)
                    TextField("Amount (PLN)", text: $model.amountText).keyboardType(.decimalPad)
                    Picker("Paid by", selection: $model.paidBy) {
                        Text("Me").tag("Me")
                        ForEach(meeting?.participantNames.filter { $0 != "Me" } ?? [], id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("New expense")
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppTheme.pink)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveExpense() }.disabled(!model.canSave)
                }
            }
        }
    }

    // MARK: - ZAPIS DO EVENTSTORE; WALIDACJA JEST W VIEWMODEL
    private func saveExpense() {
        guard var meeting, let expense = model.makeExpense() else { return }
        meeting.expenses.append(expense)
        store.update(meeting)
        dismiss()
    }
}
