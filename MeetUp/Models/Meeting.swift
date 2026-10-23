import Foundation

struct Meeting: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var location: String
    var details: String
    var category: MeetingCategory
    var participantNames: [String] = []
    var tasks: [MeetingTask] = []
}

enum MeetingCategory: String, CaseIterable, Codable, Identifiable {
    case social = "Social"
    case food = "Food"
    case outdoors = "Outdoors"
    case games = "Games"
    case other = "Other"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .social: "person.2"
        case .food: "fork.knife"
        case .outdoors: "leaf"
        case .games: "gamecontroller"
        case .other: "calendar"
        }
    }
}

struct MeetingTask: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isDone: Bool = false
}
