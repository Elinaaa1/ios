import SwiftUI

// MARK: - PROFIL: WYLACZNIE PREZENTACJA STATYSTYK
struct ProfileView: View {
    @EnvironmentObject private var store: EventStore
    private var stats: ProfileStatistics { ProfileStatistics(meetings: store.meetings, upcoming: store.upcomingMeetings) }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 10) {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .font(.system(size: 45)).foregroundStyle(.white)
                            .frame(width: 90, height: 90)
                            .background(AppTheme.mainGradient, in: Circle())
                        Text("My MeetUp era ✨").font(.title.bold())
                        Text("Local demo profile").font(.subheadline)
                    }.foregroundStyle(AppTheme.textPrimary)
                        .frame(maxWidth: .infinity).padding(25)
                        .background(AppTheme.softGradient, in: RoundedRectangle(cornerRadius: 26))
                    VStack(spacing: 14) {
                        row("Events", "\(stats.events)")
                        row("Friends", "\(store.friends.count)")
                        row("Upcoming", "\(stats.upcoming)")
                        row("Completed tasks", "\(stats.completedTasks)")
                        row("Recorded expenses", stats.totalExpenses.formatted(.currency(code: "PLN")))
                    }.slayCard()
                    Text("Your data stays on this device. Shared cloud accounts are not enabled yet.")
                        .font(.caption).foregroundStyle(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }
    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(AppTheme.textPrimary)
            Spacer()
            Text(value).fontWeight(.bold).foregroundStyle(AppTheme.pink)
        }
    }
}
