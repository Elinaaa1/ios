import Foundation

// MARK: - STATUS WYDARZENIA
// Status zapisujemy jako String, aby mozna go bylo kodowac do JSON.
enum EventStatus: String, CaseIterable, Codable, Identifiable {
    case planned = "Planned"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .planned: "calendar"
        case .confirmed: "checkmark.seal"
        case .completed: "checkmark.circle.fill"
        case .cancelled: "xmark.circle"
        }
    }
}
