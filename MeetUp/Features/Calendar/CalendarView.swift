import SwiftUI

// MARK: - EKRAN KALENDARZA SPOTKAN
// View tylko prezentuje dane i przekazuje akcje do CalendarViewModel.
struct CalendarView: View {
    @EnvironmentObject private var store: EventStore
    @StateObject private var viewModel = CalendarViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("YOUR SOCIAL CALENDAR ✨").font(.caption.bold())
                        Text("Make every day count").font(.title2.bold())
                    }
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(22)
                    .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 24))
                    monthHeader
                    calendarGrid
                    selectedDayEvents
                }
                .padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Calendar")
            .tint(AppTheme.pink)
            .navigationDestination(for: UUID.self) { id in
                EventDetailView(meetingID: id)
            }
        }
    }

    // MARK: - ZMIANA MIESIACA
    private var monthHeader: some View {
        HStack {
            Text(viewModel.monthTitle.capitalized)
                .font(.title2.bold())
            Spacer()
            Button { viewModel.changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel("Previous month")
            Button { viewModel.changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right")
            }
            .accessibilityLabel("Next month")
        }
        .foregroundStyle(AppTheme.textPrimary)
        .buttonStyle(.bordered)
    }

    // MARK: - SIATKA DAT I OZNACZENIA SPOTKAN
    private var calendarGrid: some View {
        VStack(spacing: 12) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(viewModel.weekdayLabels.enumerated()), id: \.offset) { entry in
                    Text(entry.element)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }

                ForEach(Array(viewModel.calendarDays.enumerated()), id: \.offset) { entry in
                    if let day = entry.element {
                        Button {
                            viewModel.selectedDate = day
                        } label: {
                            VStack(spacing: 5) {
                                Text(day.formatted(.dateTime.day()))
                                    .font(.subheadline.weight(.medium))
                                    .frame(maxWidth: .infinity)
                                Circle()
                                    .fill(AppTheme.turquoise)
                                    .frame(width: 6, height: 6)
                                    .opacity(viewModel.meetings(on: day, from: store.meetings).isEmpty ? 0 : 1)
                            }
                            .frame(height: 46)
                            .foregroundStyle(viewModel.isSelected(day) ? .white : AppTheme.textPrimary)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.isSelected(day) ? AppTheme.pink : .clear)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.isToday(day) && !viewModel.isSelected(day) ? AppTheme.pink : .clear, lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(height: 46)
                    }
                }
            }
        }
        .padding(14)
        .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 22))
    }

    // MARK: - SPOTKANIA W WYBRANYM DNIU
    private var selectedDayEvents: some View {
        let events = viewModel.meetings(on: viewModel.selectedDate, from: store.meetings)
        return VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.selectedDate.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
            if events.isEmpty {
                Text("No events on this day")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 16)
            } else {
                ForEach(events) { meeting in
                    NavigationLink(value: meeting.id) {
                        EventCard(meeting: meeting)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
