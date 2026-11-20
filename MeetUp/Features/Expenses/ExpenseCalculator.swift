import Foundation

// MARK: - LOGIKA FINANSOWA, NIEZALEZNA OD SWIFTUI
struct ExpenseCalculator {
    static func total(for expenses: [MeetingExpense]) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    static func share(for meeting: Meeting) -> Double {
        total(for: meeting.expenses) / Double(meeting.participantNames.count + 1)
    }
}
