import Foundation
import UserNotifications

// MARK: - LOKALNE POWIADOMIENIA IOS
// Serwis nie wyswietla interfejsu: tworzy/aktualizuje/usuwa przypomnienia.
@MainActor
final class ReminderService {
    static let shared = ReminderService()
    private init() {}

    private func notificationID(for meeting: Meeting) -> String {
        "meetup.reminder.\(meeting.id.uuidString)"
    }

    // MARK: - USUNIECIE STAREGO PRZYPOMNIENIA
    func cancel(for meeting: Meeting) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [notificationID(for: meeting)]
        )
    }

    // MARK: - SYNCHRONIZACJA PRZYPOMNIENIA Z DANYMI SPOTKANIA
    func refresh(for meeting: Meeting) async {
        cancel(for: meeting)

        // Nie przypominamy o zakonczonych, anulowanych ani przeszlych wydarzeniach.
        guard meeting.reminder != .none,
              meeting.status != .cancelled,
              meeting.status != .completed else { return }

        let reminderDate = meeting.date.addingTimeInterval(
            TimeInterval(-meeting.reminder.rawValue * 60)
        )
        guard reminderDate > Date() else { return }

        let notificationCenter = UNUserNotificationCenter.current()
        do {
            // System pokazuje prosbe o uprawnienia przy pierwszej probie.
            let allowed = try await notificationCenter.requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            guard allowed else { return }

            let content = UNMutableNotificationContent()
            content.title = "Upcoming meetup: \(meeting.title)"
            content.body = "Your event starts soon. Check the details in MeetUp."
            content.sound = .default

            let dateParts = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: reminderDate
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateParts,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: notificationID(for: meeting),
                content: content,
                trigger: trigger
            )
            try await notificationCenter.add(request)
        } catch {
            // Zdarzenie zostaje zapisane, nawet jesli iOS odmowi powiadomienia.
            print("Unable to schedule reminder: \(error.localizedDescription)")
        }
    }
}
