import Foundation
import Combine

@MainActor
final class EventStore: ObservableObject {
    @Published private(set) var meetings: [Meeting] = [] {
        didSet { save() }
    }
    @Published private(set) var friends: [String] = [] {
        didSet { saveFriends() }
    }

    private let meetingsKey = "meetup.meetings.v1"
    private let friendsKey = "meetup.friends.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: meetingsKey),
           let decoded = try? JSONDecoder().decode([Meeting].self, from: data) {
            meetings = decoded
        }
        if let data = UserDefaults.standard.data(forKey: friendsKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            friends = decoded
        }
    }

    var sortedMeetings: [Meeting] { meetings.sorted { $0.date < $1.date } }
    var upcomingMeetings: [Meeting] { sortedMeetings.filter { $0.date >= Date() } }

    func add(_ meeting: Meeting) { meetings.append(meeting) }

    func update(_ meeting: Meeting) {
        guard let index = meetings.firstIndex(where: { $0.id == meeting.id }) else { return }
        meetings[index] = meeting
    }

    func delete(_ id: UUID) { meetings.removeAll { $0.id == id } }

    func addFriend(_ name: String) {
        let clean = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty, !friends.contains(where: { $0.localizedCaseInsensitiveCompare(clean) == .orderedSame }) else { return }
        friends.append(clean)
        friends.sort()
    }

    func removeFriend(_ name: String) { friends.removeAll { $0 == name } }

    private func save() {
        guard let data = try? JSONEncoder().encode(meetings) else { return }
        UserDefaults.standard.set(data, forKey: meetingsKey)
    }

    private func saveFriends() {
        guard let data = try? JSONEncoder().encode(friends) else { return }
        UserDefaults.standard.set(data, forKey: friendsKey)
    }
}
