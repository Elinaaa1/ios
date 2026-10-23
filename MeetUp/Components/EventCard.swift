import SwiftUI

struct EventCard: View {
    let meeting: Meeting

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: meeting.category.symbol)
                .font(.title2)
                .foregroundStyle(.indigo)
                .frame(width: 50, height: 50)
                .background(.indigo.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 5) {
                Text(meeting.title).font(.headline)
                Text(meeting.date, format: .dateTime.day().month().year().hour().minute())
                    .font(.subheadline).foregroundStyle(.secondary)
                if !meeting.location.isEmpty {
                    Label(meeting.location, systemImage: "mappin")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
