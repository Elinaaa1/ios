// MARK: - MODEL WYDATKU
// Pojedynczy wydatek: opis, kwota i platnik.

import Foundation

struct MeetingExpense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var paidBy: String
}
