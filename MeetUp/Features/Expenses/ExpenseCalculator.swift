import Foundation

// MARK: - LOGIKA OBLICZANIA WYDATKOW

struct ExpenseCalculator {

    // Obliczanie lacznej sumy wydatkow
    static func calculateTotal(
        expenses: [MeetingExpense]
    ) -> Double {
        expenses.reduce(0) { sum, expense in
            sum + expense.amount
        }
    }

    // Obliczanie kosztu na jedna osobe
    static func calculatePerPerson(
        expenses: [MeetingExpense],
        participantsCount: Int
    ) -> Double {
        guard participantsCount > 0 else { return 0 }

        return calculateTotal(expenses: expenses)
            / Double(participantsCount)
    }
}
