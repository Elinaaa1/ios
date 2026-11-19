import Foundation

// MARK: - CZAS PRZYPOMNIENIA PRZED SPOTKANIEM
// 0 oznacza, ze nie tworzymy powiadomienia.
enum ReminderOption: Int, CaseIterable, Codable, Identifiable {
    case none = 0
    case fifteenMinutes = 15
    case oneHour = 60
    case oneDay = 1440

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .none: "Off"
        case .fifteenMinutes: "15 minutes before"
        case .oneHour: "1 hour before"
        case .oneDay: "1 day before"
        }
    }
}
