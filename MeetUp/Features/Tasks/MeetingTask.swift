// MARK: - MODEL ZADANIA
// Element listy przygotowan: tytul i status wykonania.

import Foundation

struct MeetingTask: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isDone: Bool = false
}
