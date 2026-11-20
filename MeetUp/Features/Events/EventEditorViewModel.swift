import Foundation
import Combine

// MARK: - LOGIKA DODAWANIA / EDYCJI WYDARZENIA
@MainActor
final class EventEditorViewModel: ObservableObject {
    @Published var title = ""
    @Published var date = Date().addingTimeInterval(3600)
    @Published var location = ""
    @Published var details = ""
    @Published var category: MeetingCategory = .social
    @Published var selectedFriends: Set<String> = []
    @Published var status: EventStatus = .planned
    @Published var reminder: ReminderOption = .none

    // MARK: - PRZEPISANIE DANYCH PODCZAS EDYCJI
    func load(_ meeting: Meeting) {
        title = meeting.title
        date = meeting.date
        location = meeting.location
        details = meeting.details
        category = meeting.category
        selectedFriends = Set(meeting.participantNames)
        status = meeting.status
        reminder = meeting.reminder
    }

    // MARK: - WALIDACJA
    var canSave: Bool { !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    // MARK: - MODELOWANIE SPOTKANIA
    // Zachowujemy istniejace tasks/polls/expenses przy edycji!
    func makeMeeting(existing: Meeting?) -> Meeting? {
        guard canSave else { return nil }
        var meeting = existing ?? Meeting(title: title, date: date, location: location, details: details, category: category)
        meeting.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        meeting.date = date
        meeting.location = location
        meeting.details = details
        meeting.category = category
        meeting.participantNames = selectedFriends.sorted()
        meeting.status = status
        meeting.reminder = reminder
        return meeting
    }
}
