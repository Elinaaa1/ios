import Foundation
import Combine

@MainActor
final class ExpenseEditorViewModel: ObservableObject {
    @Published var title = ""
    @Published var amountText = ""
    @Published var paidBy = "Me"

    // MARK: - WALIDACJA KWOTY
    var amount: Double? {
        guard let value = Double(amountText.replacingOccurrences(of: ",", with: ".")),
              value.isFinite, value > 0 else { return nil }
        return value
    }
    var canSave: Bool { !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && amount != nil }

    // MARK: - PRZYGOTOWANIE NOWEGO WYDATKU
    func makeExpense() -> MeetingExpense? {
        guard canSave, let amount else { return nil }
        return MeetingExpense(title: title.trimmingCharacters(in: .whitespacesAndNewlines), amount: amount, paidBy: paidBy)
    }
}
