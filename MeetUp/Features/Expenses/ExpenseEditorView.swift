// MARK: - DODAWANIE WYDATKU
// Formularz zapisu kosztow do wybranego spotkania.

import SwiftUI

struct ExpenseEditorView: View {
    @EnvironmentObject private var store: EventStore
    @Environment(\.dismiss) private var dismiss

    let meetingID: UUID
    @State private var title = ""
    @State private var amountText = ""
    @State private var paidBy = "Me"

    private var meeting: Meeting? {
        store.meetings.first { $0.id == meetingID }
    }

    private var validAmount: Double? {
        guard let value = Double(amountText.replacingOccurrences(of: ",", with: ".")),
              value.isFinite, value > 0 else { return nil }
        return value
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("What was purchased?", text: $title)
                TextField("Amount (PLN)", text: $amountText)
                    .keyboardType(.decimalPad)
                Picker("Paid by", selection: $paidBy) {
                    Text("Me").tag("Me")
                    ForEach(meeting?.participantNames ?? [], id: \.self) { name in
                        Text(name).tag(name)
                    }
                }
            }
            .navigationTitle("New expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveExpense() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || validAmount == nil)
                }
            }
        }
    }

    // MARK: - AKCJA UZYTKOWNIKA
    private func saveExpense() {
        guard var updated = meeting, let amount = validAmount else { return }
        updated.expenses.append(MeetingExpense(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            paidBy: paidBy
        ))
        store.update(updated)
        dismiss()
    }
}
