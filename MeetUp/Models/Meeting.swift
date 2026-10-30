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
    var expenses: [MeetingExpense] = []

    enum CodingKeys: String, CodingKey {
        case id, title, date, location, details, category, participantNames, tasks, expenses
    }

    init(id: UUID = UUID(), title: String, date: Date, location: String,
         details: String, category: MeetingCategory, participantNames: [String] = [],
         tasks: [MeetingTask] = [], expenses: [MeetingExpense] = []) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.details = details
        self.category = category
        self.participantNames = participantNames
        self.tasks = tasks
        self.expenses = expenses
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        date = try c.decode(Date.self, forKey: .date)
        location = try c.decode(String.self, forKey: .location)
        details = try c.decode(String.self, forKey: .details)
        category = try c.decode(MeetingCategory.self, forKey: .category)
        participantNames = try c.decodeIfPresent([String].self, forKey: .participantNames) ?? []
        tasks = try c.decodeIfPresent([MeetingTask].self, forKey: .tasks) ?? []
        expenses = try c.decodeIfPresent([MeetingExpense].self, forKey: .expenses) ?? []
    }

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


struct MeetingExpense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var amount: Double
    var paidBy: String
}
