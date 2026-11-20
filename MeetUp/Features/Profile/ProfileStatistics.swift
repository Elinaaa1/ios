import Foundation

// MARK: - STATYSTYKI WYLICZANE BEZ SWIFTUI
struct ProfileStatistics {
    let events: Int
    let upcoming: Int
    let completedTasks: Int
    let totalExpenses: Double
    init(meetings: [Meeting], upcoming: [Meeting]) {
        events = meetings.count
        self.upcoming = upcoming.count
        completedTasks = meetings.flatMap(\.tasks).filter(\.isDone).count
        totalExpenses = meetings.flatMap(\.expenses).reduce(0) { $0 + $1.amount }
    }
}
