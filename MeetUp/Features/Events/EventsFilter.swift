import Foundation

// MARK: - FILTROWANIE WYDARZEN (ODDZIELONE OD INTERFEJSU)
struct EventsFilter {
    static func apply(_ meetings: [Meeting], search: String, category: String) -> [Meeting] {
        meetings.filter { meeting in
            let queryOK = search.isEmpty || meeting.title.localizedCaseInsensitiveContains(search) || meeting.location.localizedCaseInsensitiveContains(search)
            let categoryOK = category == "All" || meeting.category.rawValue == category
            return queryOK && categoryOK
        }
    }
}
