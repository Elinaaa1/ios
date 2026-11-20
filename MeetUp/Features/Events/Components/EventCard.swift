import SwiftUI

// MARK: - WSPOLNA KARTA WYDARZENIA W HOME / EVENTS / CALENDAR
struct EventCard: View {
    let meeting: Meeting
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: meeting.category.symbol)
                .font(.title2.bold()).foregroundStyle(.white)
                .frame(width: 54, height: 54)
                .background(AppTheme.mainGradient, in: RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 7) {
                Text(meeting.title).font(.headline).foregroundStyle(AppTheme.textPrimary)
                Label(meeting.date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                if !meeting.location.isEmpty { Label(meeting.location, systemImage: "mappin") }
            }
            .font(.subheadline).foregroundStyle(AppTheme.textSecondary)
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").foregroundStyle(AppTheme.pink)
        }.slayCard()
    }
}
