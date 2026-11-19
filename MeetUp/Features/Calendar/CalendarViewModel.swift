import Foundation
import Combine

// MARK: - LOGIKA KALENDARZA (BEZ ELEMENTOW INTERFEJSU)
@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published private(set) var displayedMonth: Date = Date()

    private let calendar = Calendar.current

    init() {
        displayedMonth = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
    }

    // MARK: - ZMIANA MIESIACA
    func changeMonth(by offset: Int) {
        guard let next = calendar.date(byAdding: .month, value: offset, to: displayedMonth),
              let monthStart = calendar.dateInterval(of: .month, for: next)?.start
        else { return }
        displayedMonth = monthStart
        selectedDate = monthStart
    }

    var monthTitle: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    // MARK: - DNI DO WYSWIETLENIA W SIATCE
    // nil = puste pole przed pierwszym dniem miesiaca.
    var calendarDays: [Date?] {
        guard let dayRange = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstDay = calendar.dateInterval(of: .month, for: displayedMonth)?.start
        else { return [] }

        let weekday = calendar.component(.weekday, from: firstDay)
        let leadingSpaces = (weekday - calendar.firstWeekday + 7) % 7
        let emptySlots = Array<Date?>(repeating: nil, count: leadingSpaces)
        let dates: [Date?] = dayRange.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: firstDay)
        }
        return emptySlots + dates
    }

    // MARK: - FILTR SPOTKAN NA WYBRANY DZIEN
    func meetings(on day: Date, from meetings: [Meeting]) -> [Meeting] {
        meetings.filter { calendar.isDate($0.date, inSameDayAs: day) }
            .sorted { $0.date < $1.date }
    }

    func isSelected(_ day: Date) -> Bool {
        calendar.isDate(day, inSameDayAs: selectedDate)
    }

    func isToday(_ day: Date) -> Bool {
        calendar.isDateInToday(day)
    }

    // MARK: - NAGLOWKI TYGODNIA ZGODNE Z USTAWIENIAMI TELEFONU
    var weekdayLabels: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return (0..<7).map { symbols[(start + $0) % 7] }
    }
}
